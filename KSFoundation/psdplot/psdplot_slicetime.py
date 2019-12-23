import os
import json
import argparse
import numpy as np
import psdplot_helper as helper
from bokeh.layouts import gridplot, column, row, layout, widgetbox
from bokeh.plotting import figure, output_file, show, save
from bokeh.models import BoxZoomTool, HoverTool, TapTool, Range1d, Span, Line, ColumnDataSource, Div, CustomJSHover, LinearColorMapper, Legend, OpenURL
from bokeh.models.glyphs import MultiLine
from bokeh.models.widgets import Toggle, Slider, Panel, Tabs, Button, CheckboxButtonGroup
from bokeh.models.callbacks import CustomJS
from bokeh.models.axes import LinearAxis
from bokeh.palettes import viridis, brewer

colors = {'hoveredlines': "#000000",
          'Acquisition': "#A4A6F6",
          'Dummy': "#a6f2dd",
          'Calibration': "#F6A4A6",
          'filler': "#CCCCCC"}

template = """
{% block preamble %}
<style>
    body {
        background: #FFFFFF;
    }
    .plot_widgets { height: 100 px;}
</style>
{% endblock %}
"""


def setupBokeh(passes):
    figs = []
    for i in range(len(passes)):
        figs.append(figure(tools="",
                           plot_height=700,
                           plot_width=700,
                           background_fill_color=colors[passes[i].mode]))
        figs[i].toolbar.logo = None
        figs[i].min_border = 10
        if passes[i].duration > 1000.:
            durationToDispl = "%.6f" % (passes[i].duration / 1000.)
            durationUnits = 's'
        else:
            durationToDispl = "%.6f" % (passes[i].duration / 1000.)
            durationUnits = 'ms'
        figs[i].title.text = passes[i].mode + ' - ' + passes[i].slicegroups[0].description + ' (1/' + str(len(passes[i].slicegroups)) + '), ' + durationToDispl + ' ' + durationUnits
        figs[i].background_fill_alpha = 0.15
        if i > 0:
            figs[i].yaxis.major_tick_line_color = None
            figs[i].yaxis.major_label_text_font_size = '0pt'
            figs[i].yaxis.visible = False
    return figs


def sliceEventSpans(figs, passes):
    spanConfig = {'color': {'hover': 'olive',
                            'tap': 'black',
                            'doubleTap': 'red'},
                  'dash': {'hover': 'dashed',
                           'tap': 'dotted',
                           'doubleTap': 'dashed'}}
    spans = {'left': [],
             'right': [],
             'top': [],
             'bottom': []}
    for fig, _pass in zip(figs, passes):
        span1 = Span(location=-1,
                     level='underlay',
                     dimension='height',
                     line_dash=spanConfig['dash']['hover'],
                     line_color=spanConfig['color']['hover'])
        span2 = Span(location=-1,
                     level='underlay',
                     dimension='height',
                     line_dash=spanConfig['dash']['hover'],
                     line_color=spanConfig['color']['hover'])
        span3 = Span(location=1000,
                     level='underlay',
                     dimension='width',
                     line_dash=spanConfig['dash']['hover'],
                     line_color=spanConfig['color']['hover'])
        span4 = Span(location=1000,
                     level='underlay',
                     dimension='width',
                     line_dash=spanConfig['dash']['hover'],
                     line_color=spanConfig['color']['hover'])
        spans['left'].append(span1)
        spans['right'].append(span2)
        spans['top'].append(span3)
        spans['bottom'].append(span4)
        fig.add_layout(span1)
        fig.add_layout(span2)
        fig.add_layout(span3)
        fig.add_layout(span4)
    return spans


def colormapFromSequences():
    numSeq = len(helper.Pass.allSequences)
    return brewer['Set3'][max(numSeq, 3)] if numSeq < 13 else viridis(numSeq)


def slicegroupColumnData(columnData, slices, colormap):
    for event in slices:
        for pos in event.slicepos:
            for k in list(set(event.__dict__.keys()).intersection(columnData.keys())):
                columnData[k].append(event.__dict__[k])
            columnData['xcenter'].append(columnData['start'][-1] + columnData['duration'][-1] / 2.0)
            columnData['ycenter'].append(pos)
            columnData['color'].append(colormap[helper.Pass.allSequences.index(event.description)] if not event.isFiller else colors['filler'])
    return


def hoverCallback(cds, events, spans):
    return CustomJS(
        args={
            'cds': cds,
            'events': events,
            'spans': spans},
        code="""
idx = cb_data.index['1d'].indices
if (idx.length) {
    for (let i = 0; i < spans['hover']['left'].length; i++) {
        spans["hover"]["left"][i].location = events.data["start"][idx];
        spans["hover"]["right"][i].location = events.data["end"][idx];
        spans["hover"]["top"][i].location = events.data["ycenter"][idx] + events.data["slicethickness"][idx] / 2.0;
        spans["hover"]["bottom"][i].location = events.data["ycenter"][idx] - events.data["slicethickness"][idx] / 2.0;
    }
}
""")


def passSlider(cds, sliceGroupData, _pass, fig):
    changeSliceGroup_cb = CustomJS(args=dict(fig=fig,
                                             cds=cds,
                                             sliceGroupDescriptions=[sg.description for sg in _pass.slicegroups],
                                             sliceGroupData=sliceGroupData),
                                   code=
"""
let sliceGroupIndex = cb_obj.value - 1;
let sliceGroupDesc = sliceGroupDescriptions[sliceGroupIndex];
let numSlicegroups = sliceGroupData.length;
console.log(sliceGroupIndex);
let passTime = 0
for (let idx = 0; idx < numSlicegroups; idx++) {
    let tempEnd = sliceGroupData[idx]["end"]
    passTime += tempEnd[tempEnd.length - 1]
}
let endTimeToDisp = (passTime).toFixed(3)
let units = 'ms'
if (passTime > 1000.0) {
    endTimeToDisp = (passTime / 1000.0).toFixed(6)
    units = 's'
}
fig.title.text = sliceGroupDesc + ' (' + (sliceGroupIndex+1) + '/' + numSlicegroups + '), ' + endTimeToDisp + ' ' + units
cds.data = sliceGroupData[sliceGroupIndex];
cds.change.emit();
""")
    numSliceGroups = len(sliceGroupData)
    slider = Slider(start=1, end=numSliceGroups, value=1, step=1, title=_pass.mode,
                    callback=changeSliceGroup_cb, bar_color="#2EA54A")
    return slider


def main(args):
    (metadata, passes) = loadPasses(filename=(args.filename))
    colorindex = np.linspace(0, 1, len(passes))
    numFillers = 5
    colorindexFiller = np.linspace(0, 1, numFillers)
    figs = setupBokeh(passes)

    firstSlice = passes[0].slicegroups[0].slices[0]
    sliceCols = firstSlice.__dict__.keys() + ['xcenter', 'ycenter', 'color']
    passColumnData = [[{c: [] for c in sliceCols if c not in ['parent']} for _ in p.slicegroups] for p in passes]

    cmap = colormapFromSequences()
    for pcd, pd in zip(passColumnData, passes):
        for pcdgroup, pdgroup in zip(pcd, pd.slicegroups):
            slicegroupColumnData(pcdgroup, pdgroup.slices, cmap)

    spans = {'hover': sliceEventSpans(figs, passes)}
    limits = helper.Pass.plotLimits()
    renderers = [{'events': []} for _ in figs]
    allCDS = [ColumnDataSource(_pass[0]) for _pass in passColumnData]

    for fig, cds, renderer, _pass in zip(figs, allCDS, renderers, passes):
        renderer['events'] = fig.rect(x='xcenter',
                                      y='ycenter',
                                      width='duration',
                                      height='slicethickness',
                                      color='color',
                                      name='event',
                                      dilate=False,
                                      line_color='gray',
                                      hover_line_color=colors['hoveredlines'],
                                      line_width=1,
                                      legend='description',
                                      source=cds)
        renderer['events'].nonselection_glyph = renderer['events'].glyph
        renderer['events'].hover_glyph.line_width = 2.5
        hover = HoverTool(callback=hoverCallback(cds, renderer['events'].data_source, spans),
                          toggleable=False,
                          names=["event"])
        url = "{}_@description.html".format(metadata['psdname'])
        tapper = TapTool(callback=OpenURL(url=url), names=['event'])
        hover.tooltips = [("Sequence", "<b>@description</b>"),
                          ("Index", "$index"),
                          ("Start", "@start{%.3f} ms"),
                          ("End", "@end{%.3f} ms"),
                          ("Duration", "@duration{%.3f} ms"),
                          ("Min. duration", "@minduration{%.3f} ms"),
                          ("Position/thickness", "@slicepos{%.3f}/@slicethickness{%.3f} mm"),
                          ("RF/Trap/Waves/Read", "@numrf{%d}/@numtrap{%d}/@numwave{%d}/@numacq{%d}")]
        hover.formatters = {
            'start': 'printf',
            'end': 'printf',
            'duration': 'printf',
            'minduration': 'printf',
            'slicepos': 'printf',
            'slicethickness': 'printf',
            'numrf': 'printf',
            'numtrap': 'printf',
            'numwave': 'printf',
            'numacq': 'printf'
        }
        bokeh_yrange = Range1d(limits['min'] - limits['padding'],
                               limits['max'] + limits['padding'])
        fig.outline_line_width = 1
        fig.outline_line_color = "black"
        fig.y_range = bokeh_yrange
        fig.x_range = Range1d(0, _pass.slicegroups[0].slices[-1].end)
        fig.xaxis.minor_tick_out = 0
        fig.add_tools(hover, tapper, BoxZoomTool())

    sliders = [passSlider(cds, pcd, _pass, fig) for cds, pcd, _pass, fig in zip(allCDS, passColumnData, passes, figs) if len(pcd) > 1]
    buttonbox = widgetbox(sliders, css_classes=["plot_widgets"])
    l = [row(row(figs), column(buttonbox))]
    #  figs[-1].add_layout(legend, 'right')
    for outdir in args.outputdir:
        outname = ("%s/%s.html" % (outdir, os.path.basename(args.filename)[:-5]))
        output_file(filename=outname, mode='inline')
        svgname = ("%s/%s.svg" % (outdir, os.path.basename(args.filename)[:-5])) if args.svg else ''
        save(l, filename=outname, template=template, title=os.path.basename(args.filename)[:-5])
        print('Saved ' + outname)
    return


def loadPasses(filename):
    with open(filename) as file:
        objects = json.load(file)
        passes = [helper.Pass(p['passmode'], p['slicegroups']) for p in objects['passes']]
        metadata = objects['metadata']
        if len(passes) == 0:
            print "Could not find any passes. Check", filename
            raise ValueError
    return (metadata, passes)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('filename',
                        type=str,
                        default=None)
    parser.add_argument('-m', '--mergefillers',
                        help=("Merge TR fillers. " +
                              "Default is on"),
                        type=int,
                        default=1)
    parser.add_argument('--svg',
                        help="Flag to save vectorized (SVG) plots",
                        action="store_true",
                        default=False)
    parser.add_argument('-o', '--outputdir',
                        help=("Where plots are saved. " +
                              "Default is current directory"),
                        type=str,
                        nargs='*',
                        default=[os.getcwd(), ])
    args = parser.parse_args()
    for n, outdir in enumerate(args.outputdir):
        args.outputdir[n] = os.path.abspath(outdir)
    main(args)
