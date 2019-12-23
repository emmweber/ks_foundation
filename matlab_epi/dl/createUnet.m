function lgraph = createUnet()

% EDIT: modify these parameters for your application.
encoderDepth = 4;
initialEncoderNumChannels = 64;
inputTileSize = [256 256 3];
convFilterSize = [3 3];
inputNumChannels = 3;
numClasses = 10;


inputlayer = imageInputLayer(inputTileSize,'Name','ImageInputLayer');

[encoder, finalNumChannels] = iCreateEncoder(encoderDepth, convFilterSize, initialEncoderNumChannels, inputNumChannels);

firstConv = createAndInitializeConvLayer(convFilterSize, finalNumChannels, ...
    2*finalNumChannels, 'Bridge-Conv-1');
firstReLU = reluLayer('Name','Bridge-ReLU-1');

secondConv = createAndInitializeConvLayer(convFilterSize, 2*finalNumChannels, ...
    2*finalNumChannels, 'Bridge-Conv-2');
secondReLU = reluLayer('Name','Bridge-ReLU-2');

encoderDecoderBridge = [firstConv; firstReLU; secondConv; secondReLU];

dropOutLayer = dropoutLayer(0.5,'Name','Bridge-DropOut');
encoderDecoderBridge = [encoderDecoderBridge; dropOutLayer];

initialDecoderNumChannels = finalNumChannels;

upConvFilterSize = 2;

[decoder, finalDecoderNumChannels] = iCreateDecoder(encoderDepth, upConvFilterSize, convFilterSize, initialDecoderNumChannels);

layers = [inputlayer; encoder; encoderDecoderBridge; decoder];


finalConv = convolution2dLayer(1,numClasses,...
    'BiasL2Factor',0,...
    'Name','Final-ConvolutionLayer');
finalConv.Weights = randn(1,1,finalDecoderNumChannels,numClasses);
finalConv.Bias = zeros(1,1,numClasses);

smLayer = softmaxLayer('Name','Softmax-Layer');
pixelClassLayer = pixelClassificationLayer('Name','Segmentation-Layer');

layers = [layers; finalConv; smLayer; pixelClassLayer];

lgraph = layerGraph(layers);

for depth = 1:encoderDepth
   startLayer = sprintf('Encoder-Stage-%d-ReLU-2',depth); 
   endLayer = sprintf('Decoder-Stage-%d-DepthConcatenation/in2',encoderDepth-depth + 1);
   lgraph = connectLayers(lgraph,startLayer, endLayer);
end

end

%--------------------------------------------------------------------------
function [encoder, finalNumChannels] = iCreateEncoder(encoderDepth, convFilterSize, initialEncoderNumChannels, inputNumChannels)

encoder = [];
for stage = 1:encoderDepth
    % Double the layer number of channels at each stage of the encoder.
    encoderNumChannels = initialEncoderNumChannels * 2^(stage-1);
    
    if stage == 1
        firstConv = createAndInitializeConvLayer(convFilterSize, inputNumChannels, encoderNumChannels, ['Encoder-Stage-' num2str(stage) '-Conv-1']);
    else
        firstConv = createAndInitializeConvLayer(convFilterSize, encoderNumChannels/2, encoderNumChannels, ['Encoder-Stage-' num2str(stage) '-Conv-1']);
    end
    firstReLU = reluLayer('Name',['Encoder-Stage-' num2str(stage) '-ReLU-1']);
    
    secondConv = createAndInitializeConvLayer(convFilterSize, encoderNumChannels, encoderNumChannels, ['Encoder-Stage-' num2str(stage) '-Conv-2']);
    secondReLU = reluLayer('Name',['Encoder-Stage-' num2str(stage) '-ReLU-2']);
    
    encoder = [encoder;firstConv; firstReLU; secondConv; secondReLU];
    
    if stage == encoderDepth
        dropOutLayer = dropoutLayer(0.5,'Name',['Encoder-Stage-' num2str(stage) '-DropOut']);
        encoder = [encoder; dropOutLayer];
    end
    
    maxPoolLayer = maxPooling2dLayer(2, 'Stride', 2, 'Name',['Encoder-Stage-' num2str(stage) '-MaxPool']);
    
    encoder = [encoder; maxPoolLayer];
end
finalNumChannels = encoderNumChannels;
end

%--------------------------------------------------------------------------
function [decoder, finalDecoderNumChannels] = iCreateDecoder(encoderDepth, upConvFilterSize, convFilterSize, initialDecoderNumChannels)

decoder = [];
for stage = 1:encoderDepth    
    % Half the layer number of channels at each stage of the decoder.
    decoderNumChannels = initialDecoderNumChannels / 2^(stage-1);
    
    upConv = createAndInitializeUpConvLayer(upConvFilterSize, 2*decoderNumChannels, decoderNumChannels, ['Decoder-Stage-' num2str(stage) '-UpConv']);
    upReLU = reluLayer('Name',['Decoder-Stage-' num2str(stage) '-UpReLU']);
    
    % Input feature channels are concatenated with deconvolved features within the decoder.
    depthConcatLayer = depthConcatenationLayer(2, 'Name', ['Decoder-Stage-' num2str(stage) '-DepthConcatenation']);
    
    firstConv = createAndInitializeConvLayer(convFilterSize, 2*decoderNumChannels, decoderNumChannels, ['Decoder-Stage-' num2str(stage) '-Conv-1']);
    firstReLU = reluLayer('Name',['Decoder-Stage-' num2str(stage) '-ReLU-1']);
    
    secondConv = createAndInitializeConvLayer(convFilterSize, decoderNumChannels, decoderNumChannels, ['Decoder-Stage-' num2str(stage) '-Conv-2']);
    secondReLU = reluLayer('Name',['Decoder-Stage-' num2str(stage) '-ReLU-2']);
    
    decoder = [decoder; upConv; upReLU; depthConcatLayer; firstConv; firstReLU; secondConv; secondReLU];
end
finalDecoderNumChannels = decoderNumChannels;
end

%--------------------------------------------------------------------------
function convLayer = createAndInitializeConvLayer(convFilterSize, inputNumChannels, outputNumChannels, layerName)

convLayer = convolution2dLayer(convFilterSize,outputNumChannels,...
    'Padding', 'same',...
    'BiasL2Factor',0,...
    'Name',layerName);

% He initialization is used
convLayer.Weights = sqrt(2/((convFilterSize(1)*convFilterSize(2))*inputNumChannels)) ...
    * randn(convFilterSize(1),convFilterSize(2), inputNumChannels, outputNumChannels);

convLayer.Bias = zeros(1,1,outputNumChannels);
convLayer.BiasLearnRateFactor = 2;
end

%--------------------------------------------------------------------------
function upConvLayer = createAndInitializeUpConvLayer(UpconvFilterSize, inputNumChannels, outputNumChannels, layerName)

upConvLayer = transposedConv2dLayer(UpconvFilterSize, outputNumChannels,...
    'Stride',2,...
    'BiasL2Factor',0,...
    'Name',layerName);

% The transposed conv filter size is a scalar
upConvLayer.Weights = sqrt(2/((UpconvFilterSize^2)*inputNumChannels)) ...
    * randn(UpconvFilterSize,UpconvFilterSize,outputNumChannels,inputNumChannels);
upConvLayer.Bias = zeros(1,1,outputNumChannels);
upConvLayer.BiasLearnRateFactor = 2;
end