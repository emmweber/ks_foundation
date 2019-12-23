
/* Converters */
void
cv_cnv_endian_ptrdiff_t( ptrdiff_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian_size_t( size_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian_wchar_t( wchar_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian_int8_t( int8_t *_ecnv_target_ ) {
	cv_cnv_endian_signed_char( (signed char *)_ecnv_target_ );
}

void
cv_cnv_endian_int16_t( int16_t *_ecnv_target_ ) {
	cv_cnv_endian_short( (short *)_ecnv_target_ );
}

void
cv_cnv_endian_int32_t( int32_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian_int64_t( int64_t *_ecnv_target_ ) {
	cv_cnv_endian_long_long( (long long *)_ecnv_target_ );
}

void
cv_cnv_endian_uint8_t( uint8_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_char( (unsigned char *)_ecnv_target_ );
}

void
cv_cnv_endian_uint16_t( uint16_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_short( (unsigned short *)_ecnv_target_ );
}

void
cv_cnv_endian_uint32_t( uint32_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian_uint64_t( uint64_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long_long( (unsigned long long *)_ecnv_target_ );
}

void
cv_cnv_endian_int_least8_t( int_least8_t *_ecnv_target_ ) {
	cv_cnv_endian_signed_char( (signed char *)_ecnv_target_ );
}

void
cv_cnv_endian_int_least16_t( int_least16_t *_ecnv_target_ ) {
	cv_cnv_endian_short( (short *)_ecnv_target_ );
}

void
cv_cnv_endian_int_least32_t( int_least32_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian_int_least64_t( int_least64_t *_ecnv_target_ ) {
	cv_cnv_endian_long_long( (long long *)_ecnv_target_ );
}

void
cv_cnv_endian_uint_least8_t( uint_least8_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_char( (unsigned char *)_ecnv_target_ );
}

void
cv_cnv_endian_uint_least16_t( uint_least16_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_short( (unsigned short *)_ecnv_target_ );
}

void
cv_cnv_endian_uint_least32_t( uint_least32_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian_uint_least64_t( uint_least64_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long_long( (unsigned long long *)_ecnv_target_ );
}

void
cv_cnv_endian_int_fast8_t( int_fast8_t *_ecnv_target_ ) {
	cv_cnv_endian_signed_char( (signed char *)_ecnv_target_ );
}

void
cv_cnv_endian_int_fast16_t( int_fast16_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian_int_fast32_t( int_fast32_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian_int_fast64_t( int_fast64_t *_ecnv_target_ ) {
	cv_cnv_endian_long_long( (long long *)_ecnv_target_ );
}

void
cv_cnv_endian_uint_fast8_t( uint_fast8_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_char( (unsigned char *)_ecnv_target_ );
}

void
cv_cnv_endian_uint_fast16_t( uint_fast16_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian_uint_fast32_t( uint_fast32_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian_uint_fast64_t( uint_fast64_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long_long( (unsigned long long *)_ecnv_target_ );
}

void
cv_cnv_endian_intptr_t( intptr_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian_uintptr_t( uintptr_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian_intmax_t( intmax_t *_ecnv_target_ ) {
	cv_cnv_endian_long_long( (long long *)_ecnv_target_ );
}

void
cv_cnv_endian_uintmax_t( uintmax_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long_long( (unsigned long long *)_ecnv_target_ );
}

void
cv_cnv_endian_s8( s8 *_ecnv_target_ ) {
	cv_cnv_endian_char( (char *)_ecnv_target_ );
}

void
cv_cnv_endian_n8( n8 *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_char( (unsigned char *)_ecnv_target_ );
}

void
cv_cnv_endian_s16( s16 *_ecnv_target_ ) {
	cv_cnv_endian_int16_t( (int16_t *)_ecnv_target_ );
}

void
cv_cnv_endian_n16( n16 *_ecnv_target_ ) {
	cv_cnv_endian_uint16_t( (uint16_t *)_ecnv_target_ );
}

void
cv_cnv_endian_s32( s32 *_ecnv_target_ ) {
	cv_cnv_endian_long( (long *)_ecnv_target_ );
}

void
cv_cnv_endian_n32( n32 *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian_s64( s64 *_ecnv_target_ ) {
	cv_cnv_endian_int64_t( (int64_t *)_ecnv_target_ );
}

void
cv_cnv_endian_n64( n64 *_ecnv_target_ ) {
	cv_cnv_endian_uint64_t( (uint64_t *)_ecnv_target_ );
}

void
cv_cnv_endian_f32( f32 *_ecnv_target_ ) {
	cv_cnv_endian_float( (float *)_ecnv_target_ );
}

void
cv_cnv_endian_f64( f64 *_ecnv_target_ ) {
	cv_cnv_endian_double( (double *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_EXT_CERD_PARAMS( struct EXT_CERD_PARAMS *_ecnv_target_ )
{
	cv_cnv_endian_s32( &_ecnv_target_->alg );
	cv_cnv_endian_s32( &_ecnv_target_->demod );
}

void
cv_cnv_endian_PSD_FILTER_GEN( PSD_FILTER_GEN *_ecnv_target_ ) {
	cv_cnv_endian_f64( &_ecnv_target_->filfrq );
	cv_cnv_endian_struct_EXT_CERD_PARAMS( &_ecnv_target_->cerd );
	cv_cnv_endian_s32( &_ecnv_target_->taps );
	cv_cnv_endian_s32( &_ecnv_target_->outputs );
	cv_cnv_endian_s32( &_ecnv_target_->prefills );
	cv_cnv_endian_s32( &_ecnv_target_->filter_slot );
}

void
cv_cnv_endian_CPRM_ENTRY_TYPE( CPRM_ENTRY_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_n32( &_ecnv_target_->receiverID );
	cv_cnv_endian_n32( &_ecnv_target_->connectorStartCh );
	cv_cnv_endian_n32( &_ecnv_target_->receiverStartCh );
	cv_cnv_endian_n32( &_ecnv_target_->numChannels );
}

void
cv_cnv_endian_CPRM_TYPE( CPRM_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_n32( &_ecnv_target_->numCprmEntries );
	cv_cnv_endian_n32( &_ecnv_target_->pad );
	{
		size_t _i0_0;
		for( _i0_0 = 0; _i0_0 < (2); ++_i0_0 ) {
			cv_cnv_endian_CPRM_ENTRY_TYPE( &_ecnv_target_->coilPortReceiverMap[_i0_0] );
		}
	}
}

void
cv_cnv_endian_COIL_PORTS_RX_MAPS_TYPE( COIL_PORTS_RX_MAPS_TYPE *_ecnv_target_ ) {
	{
		size_t _i1_0;
		for( _i1_0 = 0; _i1_0 < (NUM_COIL_CONNECTORS); ++_i1_0 ) {
			cv_cnv_endian_CPRM_TYPE( &_ecnv_target_->cprm[_i1_0] );
		}
	}
}

void
cv_cnv_endian_struct_CTMEntry( struct CTMEntry *_ecnv_target_ )
{
	cv_cnv_endian_n8( &_ecnv_target_->receiverID );
	cv_cnv_endian_n8( &_ecnv_target_->receiverChannel );
	cv_cnv_endian_n16( &_ecnv_target_->entryMask );
}

void
cv_cnv_endian_CTMEntryType( CTMEntryType *_ecnv_target_ ) {
	cv_cnv_endian_struct_CTMEntry( (struct CTMEntry *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_QuadVolWeight( struct QuadVolWeight *_ecnv_target_ )
{
	cv_cnv_endian_n8( &_ecnv_target_->receiverID );
	cv_cnv_endian_n8( &_ecnv_target_->receiverChannel );
	{
		size_t _i2_0;
		for( _i2_0 = 0; _i2_0 < (2); ++_i2_0 ) {
			cv_cnv_endian_n8( &_ecnv_target_->pad[_i2_0] );
		}
	}
	cv_cnv_endian_f32( &_ecnv_target_->recWeight );
	cv_cnv_endian_f32( &_ecnv_target_->recPhaseDeg );
}

void
cv_cnv_endian_QuadVolWeightType( QuadVolWeightType *_ecnv_target_ ) {
	cv_cnv_endian_struct_QuadVolWeight( (struct QuadVolWeight *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_CTTEntry( struct CTTEntry *_ecnv_target_ )
{
	{
		size_t _i3_0;
		for( _i3_0 = 0; _i3_0 < (128); ++_i3_0 ) {
			cv_cnv_endian_s8( &_ecnv_target_->logicalCoilName[_i3_0] );
		}
	}
	{
		size_t _i4_0;
		for( _i4_0 = 0; _i4_0 < (32); ++_i4_0 ) {
			cv_cnv_endian_s8( &_ecnv_target_->clinicalCoilName[_i4_0] );
		}
	}
	cv_cnv_endian_n32( &_ecnv_target_->configUID );
	cv_cnv_endian_n32( &_ecnv_target_->coilTypeMask );
	cv_cnv_endian_n32( &_ecnv_target_->isActiveScanConfig );
	{
		size_t _i5_0;
		for( _i5_0 = 0; _i5_0 < (256); ++_i5_0 ) {
			cv_cnv_endian_CTMEntryType( &_ecnv_target_->channelTranslationMap[_i5_0] );
		}
	}
	{
		size_t _i6_0;
		for( _i6_0 = 0; _i6_0 < (16); ++_i6_0 ) {
			cv_cnv_endian_QuadVolWeightType( &_ecnv_target_->quadVolReceiveWeights[_i6_0] );
		}
	}
	cv_cnv_endian_n32( &_ecnv_target_->numChannels );
}

void
cv_cnv_endian_ChannelTransTableEntryType( ChannelTransTableEntryType *_ecnv_target_ ) {
	cv_cnv_endian_struct_CTTEntry( (struct CTTEntry *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__INSTALL_COIL_INFO_( struct _INSTALL_COIL_INFO_ *_ecnv_target_ )
{
	{
		size_t _i7_0;
		for( _i7_0 = 0; _i7_0 < ((32 + 8)); ++_i7_0 ) {
			cv_cnv_endian_char( &_ecnv_target_->coilCode[_i7_0] );
		}
	}
	cv_cnv_endian_int( &_ecnv_target_->isInCoilDatabase );
}

void
cv_cnv_endian_INSTALL_COIL_INFO( INSTALL_COIL_INFO *_ecnv_target_ ) {
	cv_cnv_endian_struct__INSTALL_COIL_INFO_( (struct _INSTALL_COIL_INFO_ *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__INSTALL_COIL_CONNECTOR_INFO_( struct _INSTALL_COIL_CONNECTOR_INFO_ *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->connector );
	cv_cnv_endian_int( &_ecnv_target_->needsInstall );
	{
		size_t _i8_0;
		for( _i8_0 = 0; _i8_0 < (4); ++_i8_0 ) {
			cv_cnv_endian_INSTALL_COIL_INFO( &_ecnv_target_->installCoilInfo[_i8_0] );
		}
	}
}

void
cv_cnv_endian_INSTALL_COIL_CONNECTOR_INFO( INSTALL_COIL_CONNECTOR_INFO *_ecnv_target_ ) {
	cv_cnv_endian_struct__INSTALL_COIL_CONNECTOR_INFO_( (struct _INSTALL_COIL_CONNECTOR_INFO_ *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_coil_config_params( struct coil_config_params *_ecnv_target_ )
{
	{
		size_t _i9_0;
		for( _i9_0 = 0; _i9_0 < (16); ++_i9_0 ) {
			cv_cnv_endian_char( &_ecnv_target_->coilName[_i9_0] );
		}
	}
	{
		size_t _i10_0;
		for( _i10_0 = 0; _i10_0 < (24); ++_i10_0 ) {
			cv_cnv_endian_char( &_ecnv_target_->GEcoilName[_i10_0] );
		}
	}
	cv_cnv_endian_short( &_ecnv_target_->pureCorrection );
	cv_cnv_endian_int( &_ecnv_target_->maxNumOfReceivers );
	cv_cnv_endian_int( &_ecnv_target_->coilType );
	cv_cnv_endian_int( &_ecnv_target_->txCoilType );
	cv_cnv_endian_int( &_ecnv_target_->fastTGmode );
	cv_cnv_endian_int( &_ecnv_target_->fastTGstartTA );
	cv_cnv_endian_int( &_ecnv_target_->fastTGstartRG );
	cv_cnv_endian_int( &_ecnv_target_->nuclide );
	cv_cnv_endian_int( &_ecnv_target_->tRPAvolumeRecEnable );
	cv_cnv_endian_int( &_ecnv_target_->pureCompatible );
	cv_cnv_endian_int( &_ecnv_target_->aps1StartTA );
	cv_cnv_endian_int( &_ecnv_target_->cflStartTA );
	cv_cnv_endian_int( &_ecnv_target_->cfhSensitiveAnatomy );
	cv_cnv_endian_float( &_ecnv_target_->pureLambda );
	cv_cnv_endian_float( &_ecnv_target_->pureTuningFactorSurface );
	cv_cnv_endian_float( &_ecnv_target_->pureTuningFactorBody );
	cv_cnv_endian_float( &_ecnv_target_->cableLoss );
	cv_cnv_endian_float( &_ecnv_target_->coilLoss );
	cv_cnv_endian_float( &_ecnv_target_->reconScale );
	cv_cnv_endian_float( &_ecnv_target_->autoshimFOV );
	{
		size_t _i11_0, _i11_1;
		for( _i11_0 = 0; _i11_0 < (4); ++_i11_0 )
		for( _i11_1 = 0; _i11_1 < (256); ++_i11_1 ) {
			cv_cnv_endian_float( &_ecnv_target_->coilWeights[_i11_0][_i11_1] );
		}
	}
	{
		size_t _i12_0;
		for( _i12_0 = 0; _i12_0 < (4); ++_i12_0 ) {
			cv_cnv_endian_ChannelTransTableEntryType( &_ecnv_target_->cttEntry[_i12_0] );
		}
	}
}

void
cv_cnv_endian_COIL_CONFIG_PARAM_TYPE( COIL_CONFIG_PARAM_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_struct_coil_config_params( (struct coil_config_params *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_application_config_param_type( struct application_config_param_type *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->aps1StartTA );
	cv_cnv_endian_int( &_ecnv_target_->cflStartTA );
	cv_cnv_endian_int( &_ecnv_target_->AScfPatLocChangeRL );
	cv_cnv_endian_int( &_ecnv_target_->AScfPatLocChangeAP );
	cv_cnv_endian_int( &_ecnv_target_->AScfPatLocChangeSI );
	cv_cnv_endian_int( &_ecnv_target_->TGpatLocChangeRL );
	cv_cnv_endian_int( &_ecnv_target_->TGpatLocChangeAP );
	cv_cnv_endian_int( &_ecnv_target_->TGpatLocChangeSI );
	cv_cnv_endian_int( &_ecnv_target_->autoshimFOV );
	cv_cnv_endian_int( &_ecnv_target_->fastTGstartTA );
	cv_cnv_endian_int( &_ecnv_target_->fastTGstartRG );
	cv_cnv_endian_int( &_ecnv_target_->fastTGmode );
	cv_cnv_endian_int( &_ecnv_target_->cfhSensitiveAnatomy );
	cv_cnv_endian_int( &_ecnv_target_->aps1Mod );
	cv_cnv_endian_int( &_ecnv_target_->aps1Plane );
	cv_cnv_endian_int( &_ecnv_target_->pureCompatible );
	cv_cnv_endian_int( &_ecnv_target_->maxFOV );
	cv_cnv_endian_int( &_ecnv_target_->assetThresh );
	cv_cnv_endian_int( &_ecnv_target_->scic_a_used );
	cv_cnv_endian_int( &_ecnv_target_->scic_s_used );
	cv_cnv_endian_int( &_ecnv_target_->scic_c_used );
	cv_cnv_endian_float( &_ecnv_target_->aps1ModFOV );
	cv_cnv_endian_float( &_ecnv_target_->aps1ModPStloc );
	cv_cnv_endian_float( &_ecnv_target_->aps1ModPSrloc );
	cv_cnv_endian_float( &_ecnv_target_->opthickPSMod );
	cv_cnv_endian_float( &_ecnv_target_->pureScale );
	cv_cnv_endian_float( &_ecnv_target_->pureCorrectionThreshold );
	cv_cnv_endian_float( &_ecnv_target_->pureLambda );
	cv_cnv_endian_float( &_ecnv_target_->pureTuningFactorSurface );
	cv_cnv_endian_float( &_ecnv_target_->pureTuningFactorBody );
	{
		size_t _i13_0;
		for( _i13_0 = 0; _i13_0 < (7); ++_i13_0 ) {
			cv_cnv_endian_float( &_ecnv_target_->scic_a[_i13_0] );
		}
	}
	{
		size_t _i14_0;
		for( _i14_0 = 0; _i14_0 < (7); ++_i14_0 ) {
			cv_cnv_endian_float( &_ecnv_target_->scic_s[_i14_0] );
		}
	}
	{
		size_t _i15_0;
		for( _i15_0 = 0; _i15_0 < (7); ++_i15_0 ) {
			cv_cnv_endian_float( &_ecnv_target_->scic_c[_i15_0] );
		}
	}
	cv_cnv_endian_int( &_ecnv_target_->assetSupported );
	{
		size_t _i16_0;
		for( _i16_0 = 0; _i16_0 < (3); ++_i16_0 ) {
			cv_cnv_endian_float( &_ecnv_target_->assetValues[_i16_0] );
		}
	}
	cv_cnv_endian_int( &_ecnv_target_->arcSupported );
	{
		size_t _i17_0;
		for( _i17_0 = 0; _i17_0 < (3); ++_i17_0 ) {
			cv_cnv_endian_float( &_ecnv_target_->arcValues[_i17_0] );
		}
	}
	cv_cnv_endian_int( &_ecnv_target_->sagCalEnabled );
	cv_cnv_endian_int( &_ecnv_target_->scenicEnabled );
	cv_cnv_endian_float( &_ecnv_target_->slice_down_sample_rate );
	cv_cnv_endian_float( &_ecnv_target_->inplane_down_sample_rate );
	cv_cnv_endian_int( &_ecnv_target_->num_levels_max );
	cv_cnv_endian_int( &_ecnv_target_->num_iterations_max );
	cv_cnv_endian_float( &_ecnv_target_->convergence_threshold );
	cv_cnv_endian_int( &_ecnv_target_->gain_clamp_mode );
	cv_cnv_endian_float( &_ecnv_target_->gain_clamp_value );
}

void
cv_cnv_endian_APPLICATION_CONFIG_PARAM_TYPE( APPLICATION_CONFIG_PARAM_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_struct_application_config_param_type( (struct application_config_param_type *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_application_config_hdr( struct application_config_hdr *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->error );
	{
		size_t _i18_0;
		for( _i18_0 = 0; _i18_0 < (32); ++_i18_0 ) {
			cv_cnv_endian_char( &_ecnv_target_->clinicalName[_i18_0] );
		}
	}
	cv_cnv_endian_APPLICATION_CONFIG_PARAM_TYPE( &_ecnv_target_->appConfig );
}

void
cv_cnv_endian_APPLICATION_CONFIG_HDR( APPLICATION_CONFIG_HDR *_ecnv_target_ ) {
	cv_cnv_endian_struct_application_config_hdr( (struct application_config_hdr *)_ecnv_target_ );
}

void
cv_cnv_endian_COIL_INFO( COIL_INFO *_ecnv_target_ ) {
	{
		size_t _i19_0;
		for( _i19_0 = 0; _i19_0 < (32); ++_i19_0 ) {
			cv_cnv_endian_s8( &_ecnv_target_->coilName[_i19_0] );
		}
	}
	cv_cnv_endian_s32( &_ecnv_target_->txIndexPri );
	cv_cnv_endian_s32( &_ecnv_target_->txIndexSec );
	cv_cnv_endian_n32( &_ecnv_target_->rxCoilType );
	cv_cnv_endian_n32( &_ecnv_target_->hubIndex );
	cv_cnv_endian_n32( &_ecnv_target_->rxNucleus );
	cv_cnv_endian_n32( &_ecnv_target_->aps1Mod );
	cv_cnv_endian_n32( &_ecnv_target_->aps1ModPlane );
	cv_cnv_endian_n32( &_ecnv_target_->coilSepDir );
	cv_cnv_endian_s32( &_ecnv_target_->assetCalThreshold );
	cv_cnv_endian_f32( &_ecnv_target_->aps1ModFov );
	cv_cnv_endian_f32( &_ecnv_target_->aps1ModSlThick );
	cv_cnv_endian_f32( &_ecnv_target_->aps1ModPsTloc );
	cv_cnv_endian_f32( &_ecnv_target_->aps1ModPsRloc );
	cv_cnv_endian_f32( &_ecnv_target_->autoshimFov );
	cv_cnv_endian_f32( &_ecnv_target_->assetCalMaxFov );
	cv_cnv_endian_f32( &_ecnv_target_->maxB1Rms );
	cv_cnv_endian_n32( &_ecnv_target_->pureCompatible );
	cv_cnv_endian_f32( &_ecnv_target_->pureLambda );
	cv_cnv_endian_f32( &_ecnv_target_->pureTuningFactorSurface );
	cv_cnv_endian_f32( &_ecnv_target_->pureTuningFactorBody );
	cv_cnv_endian_n32( &_ecnv_target_->numChannels );
	cv_cnv_endian_f32( &_ecnv_target_->switchingSpeed );
}

void
cv_cnv_endian_TX_COIL_INFO( TX_COIL_INFO *_ecnv_target_ ) {
	cv_cnv_endian_s32( &_ecnv_target_->coilAtten );
	cv_cnv_endian_n32( &_ecnv_target_->txCoilType );
	cv_cnv_endian_n32( &_ecnv_target_->txPosition );
	cv_cnv_endian_n32( &_ecnv_target_->txNucleus );
	cv_cnv_endian_n32( &_ecnv_target_->txAmp );
	cv_cnv_endian_f32( &_ecnv_target_->maxB1Peak );
	cv_cnv_endian_f32( &_ecnv_target_->maxB1Squared );
	cv_cnv_endian_f32( &_ecnv_target_->cableLoss );
	cv_cnv_endian_f32( &_ecnv_target_->coilLoss );
	{
		size_t _i20_0;
		for( _i20_0 = 0; _i20_0 < (10); ++_i20_0 ) {
			cv_cnv_endian_f32( &_ecnv_target_->reflCoeffSquared[_i20_0] );
		}
	}
	cv_cnv_endian_f32( &_ecnv_target_->reflCoeffMassOffset );
	cv_cnv_endian_f32( &_ecnv_target_->reflCoeffCurveType );
	{
		size_t _i21_0;
		for( _i21_0 = 0; _i21_0 < (8); ++_i21_0 ) {
			cv_cnv_endian_f32( &_ecnv_target_->exposedMass[_i21_0] );
		}
	}
	{
		size_t _i22_0;
		for( _i22_0 = 0; _i22_0 < (8); ++_i22_0 ) {
			cv_cnv_endian_f32( &_ecnv_target_->lowSarExposedMass[_i22_0] );
		}
	}
	{
		size_t _i23_0;
		for( _i23_0 = 0; _i23_0 < (12); ++_i23_0 ) {
			cv_cnv_endian_f32( &_ecnv_target_->jstd[_i23_0] );
		}
	}
	{
		size_t _i24_0;
		for( _i24_0 = 0; _i24_0 < (12); ++_i24_0 ) {
			cv_cnv_endian_f32( &_ecnv_target_->meanJstd[_i24_0] );
		}
	}
	cv_cnv_endian_f32( &_ecnv_target_->separationStdev );
}

void
cv_cnv_endian_struct__psd_coil_info_( struct _psd_coil_info_ *_ecnv_target_ )
{
	{
		size_t _i25_0;
		for( _i25_0 = 0; _i25_0 < (10); ++_i25_0 ) {
			cv_cnv_endian_COIL_INFO( &_ecnv_target_->imgRcvCoilInfo[_i25_0] );
		}
	}
	{
		size_t _i26_0;
		for( _i26_0 = 0; _i26_0 < (10); ++_i26_0 ) {
			cv_cnv_endian_COIL_INFO( &_ecnv_target_->volRcvCoilInfo[_i26_0] );
		}
	}
	{
		size_t _i27_0;
		for( _i27_0 = 0; _i27_0 < (10); ++_i27_0 ) {
			cv_cnv_endian_COIL_INFO( &_ecnv_target_->fullRcvCoilInfo[_i27_0] );
		}
	}
	{
		size_t _i28_0;
		for( _i28_0 = 0; _i28_0 < (5); ++_i28_0 ) {
			cv_cnv_endian_TX_COIL_INFO( &_ecnv_target_->txCoilInfo[_i28_0] );
		}
	}
	cv_cnv_endian_int( &_ecnv_target_->numCoils );
}

void
cv_cnv_endian_PSD_COIL_INFO( PSD_COIL_INFO *_ecnv_target_ ) {
	cv_cnv_endian_struct__psd_coil_info_( (struct _psd_coil_info_ *)_ecnv_target_ );
}

void
cv_cnv_endian_power_monitor_table_t( power_monitor_table_t *_ecnv_target_ ) {
	cv_cnv_endian_s16( &_ecnv_target_->pmPredictSAR );
	cv_cnv_endian_s16( &_ecnv_target_->pmContinuousUpdate );
}

void
cv_cnv_endian_entry_point_table_t( entry_point_table_t *_ecnv_target_ ) {
	{
		size_t _i29_0;
		for( _i29_0 = 0; _i29_0 < (16); ++_i29_0 ) {
			cv_cnv_endian_char( &_ecnv_target_->epname[_i29_0] );
		}
	}
	cv_cnv_endian_n32( &_ecnv_target_->epamph );
	cv_cnv_endian_n32( &_ecnv_target_->epampb );
	cv_cnv_endian_n32( &_ecnv_target_->epamps );
	cv_cnv_endian_n32( &_ecnv_target_->epampc );
	cv_cnv_endian_n32( &_ecnv_target_->epwidthh );
	cv_cnv_endian_n32( &_ecnv_target_->epwidthb );
	cv_cnv_endian_n32( &_ecnv_target_->epwidths );
	cv_cnv_endian_n32( &_ecnv_target_->epwidthc );
	cv_cnv_endian_n32( &_ecnv_target_->epdcycleh );
	cv_cnv_endian_n32( &_ecnv_target_->epdcycleb );
	cv_cnv_endian_n32( &_ecnv_target_->epdcycles );
	cv_cnv_endian_n32( &_ecnv_target_->epdcyclec );
	cv_cnv_endian_n8( &_ecnv_target_->epsmode );
	cv_cnv_endian_n8( &_ecnv_target_->epfilter );
	cv_cnv_endian_n8( &_ecnv_target_->eprcvrband );
	cv_cnv_endian_n8( &_ecnv_target_->eprcvrinput );
	cv_cnv_endian_n8( &_ecnv_target_->eprcvrbias );
	cv_cnv_endian_n8( &_ecnv_target_->eptrdriver );
	cv_cnv_endian_n8( &_ecnv_target_->epfastrec );
	cv_cnv_endian_s16( &_ecnv_target_->epxmtadd );
	cv_cnv_endian_s16( &_ecnv_target_->epprexres );
	cv_cnv_endian_s16( &_ecnv_target_->epshldctrl );
	cv_cnv_endian_s16( &_ecnv_target_->epgradcoil );
	cv_cnv_endian_n32( &_ecnv_target_->eppkpower );
	cv_cnv_endian_n32( &_ecnv_target_->epseqtime );
	cv_cnv_endian_s16( &_ecnv_target_->epstartrec );
	cv_cnv_endian_s16( &_ecnv_target_->ependrec );
	cv_cnv_endian_power_monitor_table_t( &_ecnv_target_->eppmtable );
	cv_cnv_endian_n8( &_ecnv_target_->epGeneralBankIndex );
	cv_cnv_endian_n8( &_ecnv_target_->epGeneralBankIndex2 );
	cv_cnv_endian_n8( &_ecnv_target_->epR1BankIndex );
	cv_cnv_endian_n8( &_ecnv_target_->epNbTransmitSelect );
	cv_cnv_endian_n8( &_ecnv_target_->epBbTransmitSelect );
	cv_cnv_endian_n32( &_ecnv_target_->epMnsConverterSelect );
	cv_cnv_endian_n32( &_ecnv_target_->epRxCoilType );
	cv_cnv_endian_f32( &_ecnv_target_->epxgd_cableirmsmax );
	cv_cnv_endian_f32( &_ecnv_target_->epcoilAC_powersum );
	cv_cnv_endian_n8( &_ecnv_target_->enableReceiveFreqBands );
	cv_cnv_endian_s32( &_ecnv_target_->offsetReceiveFreqLower );
	cv_cnv_endian_s32( &_ecnv_target_->offsetReceiveFreqHigher );
}

void
cv_cnv_endian_ENTRY_POINT_TABLE( ENTRY_POINT_TABLE *_ecnv_target_ ) {
	cv_cnv_endian_entry_point_table_t( (entry_point_table_t *)_ecnv_target_ );
}

void
cv_cnv_endian_ENTRY_PNT_TABLE( ENTRY_PNT_TABLE *_ecnv_target_ ) {
	cv_cnv_endian_entry_point_table_t( (entry_point_table_t *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_ANATOMY_ATTRIBUTE( enum ANATOMY_ATTRIBUTE *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_ANATOMY_ATTRIBUTE_E( ANATOMY_ATTRIBUTE_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_ANATOMY_ATTRIBUTE( (enum ANATOMY_ATTRIBUTE *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_ANATOMY_ATTRIBUTE_CATEGORY( enum ANATOMY_ATTRIBUTE_CATEGORY *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_ANATOMY_ATTRIBUTE_CATEGORY_E( ANATOMY_ATTRIBUTE_CATEGORY_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_ANATOMY_ATTRIBUTE_CATEGORY( (enum ANATOMY_ATTRIBUTE_CATEGORY *)_ecnv_target_ );
}

void
cv_cnv_endian_SCAN_INFO( SCAN_INFO *_ecnv_target_ ) {
	cv_cnv_endian_float( &_ecnv_target_->oprloc );
	cv_cnv_endian_float( &_ecnv_target_->opphasoff );
	cv_cnv_endian_float( &_ecnv_target_->optloc );
	cv_cnv_endian_float( &_ecnv_target_->oprloc_shift );
	cv_cnv_endian_float( &_ecnv_target_->opphasoff_shift );
	cv_cnv_endian_float( &_ecnv_target_->optloc_shift );
	cv_cnv_endian_float( &_ecnv_target_->opfov_freq_scale );
	cv_cnv_endian_float( &_ecnv_target_->opfov_phase_scale );
	cv_cnv_endian_float( &_ecnv_target_->opslthick_scale );
	{
		size_t _i30_0;
		for( _i30_0 = 0; _i30_0 < (9); ++_i30_0 ) {
			cv_cnv_endian_float( &_ecnv_target_->oprot[_i30_0] );
		}
	}
}

void
cv_cnv_endian_PSC_INFO( PSC_INFO *_ecnv_target_ ) {
	cv_cnv_endian_float( &_ecnv_target_->oppsctloc );
	cv_cnv_endian_float( &_ecnv_target_->oppscrloc );
	cv_cnv_endian_float( &_ecnv_target_->oppscphasoff );
	{
		size_t _i31_0;
		for( _i31_0 = 0; _i31_0 < (9); ++_i31_0 ) {
			cv_cnv_endian_float( &_ecnv_target_->oppscrot[_i31_0] );
		}
	}
	cv_cnv_endian_int( &_ecnv_target_->oppsclenx );
	cv_cnv_endian_int( &_ecnv_target_->oppscleny );
	cv_cnv_endian_int( &_ecnv_target_->oppsclenz );
}

void
cv_cnv_endian_GIR_INFO( GIR_INFO *_ecnv_target_ ) {
	cv_cnv_endian_float( &_ecnv_target_->opgirthick );
	cv_cnv_endian_float( &_ecnv_target_->opgirtloc );
	{
		size_t _i32_0;
		for( _i32_0 = 0; _i32_0 < (9); ++_i32_0 ) {
			cv_cnv_endian_float( &_ecnv_target_->opgirrot[_i32_0] );
		}
	}
}

void
cv_cnv_endian_DATA_ACQ_ORDER( DATA_ACQ_ORDER *_ecnv_target_ ) {
	cv_cnv_endian_short( &_ecnv_target_->slloc );
	cv_cnv_endian_short( &_ecnv_target_->slpass );
	cv_cnv_endian_short( &_ecnv_target_->sltime );
}

void
cv_cnv_endian_RSP_INFO( RSP_INFO *_ecnv_target_ ) {
	cv_cnv_endian_float( &_ecnv_target_->rsptloc );
	cv_cnv_endian_float( &_ecnv_target_->rsprloc );
	cv_cnv_endian_float( &_ecnv_target_->rspphasoff );
	cv_cnv_endian_int( &_ecnv_target_->slloc );
}

void
cv_cnv_endian_PHASE_OFF( PHASE_OFF *_ecnv_target_ ) {
	cv_cnv_endian_int( &_ecnv_target_->ysign );
	cv_cnv_endian_int( &_ecnv_target_->yoffs );
}

void
cv_cnv_endian_RSP_PSC_INFO( RSP_PSC_INFO *_ecnv_target_ ) {
	cv_cnv_endian_float( &_ecnv_target_->rsppsctloc );
	cv_cnv_endian_float( &_ecnv_target_->rsppscrloc );
	cv_cnv_endian_float( &_ecnv_target_->rsppscphasoff );
	{
		size_t _i33_0;
		for( _i33_0 = 0; _i33_0 < (10); ++_i33_0 ) {
			cv_cnv_endian_long( &_ecnv_target_->rsppscrot[_i33_0] );
		}
	}
	cv_cnv_endian_int( &_ecnv_target_->rsppsclenx );
	cv_cnv_endian_int( &_ecnv_target_->rsppscleny );
	cv_cnv_endian_int( &_ecnv_target_->rsppsclenz );
}

void
cv_cnv_endian_WF_PROCESSOR( WF_PROCESSOR *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_WF_HARDWARE_TYPE( WF_HARDWARE_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_HW_DIRECTION( HW_DIRECTION *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_SSP_S_ATTRIB( SSP_S_ATTRIB *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_PSD_EXIT_ARG( PSD_EXIT_ARG *_ecnv_target_ ) {
	cv_cnv_endian_s32( &_ecnv_target_->abcode );
	{
		size_t _i34_0;
		for( _i34_0 = 0; _i34_0 < (256); ++_i34_0 ) {
			cv_cnv_endian_char( &_ecnv_target_->text_string[_i34_0] );
		}
	}
	{
		size_t _i35_0;
		for( _i35_0 = 0; _i35_0 < (16); ++_i35_0 ) {
			cv_cnv_endian_char( &_ecnv_target_->text_arg[_i35_0] );
		}
	}
	{
		size_t _i36_0;
		for( _i36_0 = 0; _i36_0 < (4); ++_i36_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->longarg[_i36_0] );
		}
	}
}

void
cv_cnv_endian_enum_GRADIENT_COILS( enum GRADIENT_COILS *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_GRADIENT_COIL_E( GRADIENT_COIL_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_GRADIENT_COILS( (enum GRADIENT_COILS *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_BODY_COIL_TYPES( enum BODY_COIL_TYPES *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_BODY_COIL_TYPE_E( BODY_COIL_TYPE_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_BODY_COIL_TYPES( (enum BODY_COIL_TYPES *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_PSD_BOARD_TYPE( enum PSD_BOARD_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_PSD_BOARD_TYPE_E( PSD_BOARD_TYPE_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_PSD_BOARD_TYPE( (enum PSD_BOARD_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_SSC_TYPE( enum SSC_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_SSC_TYPE_E( SSC_TYPE_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_SSC_TYPE( (enum SSC_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_GRADIENT_COIL_METHOD( enum GRADIENT_COIL_METHOD *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_GRADIENT_COIL_METHOD_E( GRADIENT_COIL_METHOD_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_GRADIENT_COIL_METHOD( (enum GRADIENT_COIL_METHOD *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_POWER_IN_HEAT_CALC( enum POWER_IN_HEAT_CALC *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_POWER_IN_HEAT_CALC_E( POWER_IN_HEAT_CALC_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_POWER_IN_HEAT_CALC( (enum POWER_IN_HEAT_CALC *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_GRADIENT_PULSE_TYPE( enum GRADIENT_PULSE_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_GRADIENT_PULSE_TYPE_E( GRADIENT_PULSE_TYPE_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_GRADIENT_PULSE_TYPE( (enum GRADIENT_PULSE_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_GRAD_PULSE( GRAD_PULSE *_ecnv_target_ ) {
	cv_cnv_endian_int( &_ecnv_target_->ptype );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->attack );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->decay );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->pw );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->amps );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->amp );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->ampd );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->ampe );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->gradfile );
	cv_cnv_endian_int( &_ecnv_target_->num );
	cv_cnv_endian_float( &_ecnv_target_->scale );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->time );
	cv_cnv_endian_int( &_ecnv_target_->tdelta );
	cv_cnv_endian_float( &_ecnv_target_->powscale );
	cv_cnv_endian_float( &_ecnv_target_->power );
	cv_cnv_endian_float( &_ecnv_target_->powpos );
	cv_cnv_endian_float( &_ecnv_target_->powneg );
	cv_cnv_endian_float( &_ecnv_target_->powabs );
	cv_cnv_endian_float( &_ecnv_target_->amptran );
	cv_cnv_endian_int( &_ecnv_target_->pwm );
	cv_cnv_endian_int( &_ecnv_target_->bridge );
	cv_cnv_endian_float( &_ecnv_target_->intabspwmcurr );
}

void
cv_cnv_endian_RF_PULSE( RF_PULSE *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( &_ecnv_target_->pw );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->amp );
	cv_cnv_endian_float( &_ecnv_target_->abswidth );
	cv_cnv_endian_float( &_ecnv_target_->effwidth );
	cv_cnv_endian_float( &_ecnv_target_->area );
	cv_cnv_endian_float( &_ecnv_target_->dtycyc );
	cv_cnv_endian_float( &_ecnv_target_->maxpw );
	cv_cnv_endian_int( &_ecnv_target_->num );
	cv_cnv_endian_float( &_ecnv_target_->max_b1 );
	cv_cnv_endian_float( &_ecnv_target_->max_int_b1_sq );
	cv_cnv_endian_float( &_ecnv_target_->max_rms_b1 );
	cv_cnv_endian_float( &_ecnv_target_->nom_fa );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->act_fa );
	cv_cnv_endian_float( &_ecnv_target_->nom_pw );
	cv_cnv_endian_float( &_ecnv_target_->nom_bw );
	cv_cnv_endian_unsigned_int( &_ecnv_target_->activity );
	cv_cnv_endian_unsigned_char( &_ecnv_target_->reference );
	cv_cnv_endian_int( &_ecnv_target_->isodelay );
	cv_cnv_endian_float( &_ecnv_target_->scale );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->res );
	cv_cnv_endian_int( &_ecnv_target_->extgradfile );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->exciter );
	cv_cnv_endian_int( &_ecnv_target_->apply_as_hadamard_factor );
}

void
cv_cnv_endian_RF_PULSE_INFO( RF_PULSE_INFO *_ecnv_target_ ) {
	cv_cnv_endian_int( &_ecnv_target_->change );
	cv_cnv_endian_int( &_ecnv_target_->newres );
}

void
cv_cnv_endian_regulatory_control_mode_e( regulatory_control_mode_e *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_enum_epic_slice_order_type_e( enum epic_slice_order_type_e *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_epic_slice_order_type( epic_slice_order_type *_ecnv_target_ ) {
	cv_cnv_endian_enum_epic_slice_order_type_e( (enum epic_slice_order_type_e *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_exciter_type( enum exciter_type *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_exciterSelection( exciterSelection *_ecnv_target_ ) {
	cv_cnv_endian_enum_exciter_type( (enum exciter_type *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_receiver_type( enum receiver_type *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_receiverSelection( receiverSelection *_ecnv_target_ ) {
	cv_cnv_endian_enum_receiver_type( (enum receiver_type *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_oscillator_source( enum oscillator_source *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_demodSelection( demodSelection *_ecnv_target_ ) {
	cv_cnv_endian_enum_oscillator_source( (enum oscillator_source *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_nav_type( enum nav_type *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_navSelection( navSelection *_ecnv_target_ ) {
	cv_cnv_endian_enum_nav_type( (enum nav_type *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_VALUE_SYSTEM_TYPE( enum VALUE_SYSTEM_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_VALUE_SYSTEM_TYPE_E( VALUE_SYSTEM_TYPE_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_VALUE_SYSTEM_TYPE( (enum VALUE_SYSTEM_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_PSD_PATIENT_ENTRY( enum PSD_PATIENT_ENTRY *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_PSD_PATIENT_ENTRY_E( PSD_PATIENT_ENTRY_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_PSD_PATIENT_ENTRY( (enum PSD_PATIENT_ENTRY *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_CAL_MODE( enum CAL_MODE *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_CAL_MODE_E( CAL_MODE_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_CAL_MODE( (enum CAL_MODE *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_RG_CAL_MODE( enum RG_CAL_MODE *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_RG_CAL_MODE_E( RG_CAL_MODE_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_RG_CAL_MODE( (enum RG_CAL_MODE *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_ADD_SCAN_TYPE( enum ADD_SCAN_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_ADD_SCAN_TYPE_E( ADD_SCAN_TYPE_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_ADD_SCAN_TYPE( (enum ADD_SCAN_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_PSD_SLTHICK_LABEL( enum PSD_SLTHICK_LABEL *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_PSD_SLTHICK_LABEL_E( PSD_SLTHICK_LABEL_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_PSD_SLTHICK_LABEL( (enum PSD_SLTHICK_LABEL *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_PSD_NAV_TYPE( enum PSD_NAV_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_PSD_NAV_TYPE_E( PSD_NAV_TYPE_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_PSD_NAV_TYPE( (enum PSD_NAV_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_PSD_FLIP_ANGLE_MODE_LABEL( enum PSD_FLIP_ANGLE_MODE_LABEL *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_PSD_FLIP_ANGLE_LABEL_E( PSD_FLIP_ANGLE_LABEL_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_PSD_FLIP_ANGLE_MODE_LABEL( (enum PSD_FLIP_ANGLE_MODE_LABEL *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_PSD_AUTO_TR_MODE_LABEL( enum PSD_AUTO_TR_MODE_LABEL *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_PSD_AUTO_TR_MODE_LABEL_E( PSD_AUTO_TR_MODE_LABEL_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_PSD_AUTO_TR_MODE_LABEL( (enum PSD_AUTO_TR_MODE_LABEL *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_CARDIAC_GATE_TYPE( enum CARDIAC_GATE_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_CARDIAC_GATE_TYPE_E( CARDIAC_GATE_TYPE_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_CARDIAC_GATE_TYPE( (enum CARDIAC_GATE_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_CHAR( CHAR *_ecnv_target_ ) {
	cv_cnv_endian_char( (char *)_ecnv_target_ );
}

void
cv_cnv_endian_SHORT( SHORT *_ecnv_target_ ) {
	cv_cnv_endian_s16( (s16 *)_ecnv_target_ );
}

void
cv_cnv_endian_INT( INT *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian_LONG( LONG *_ecnv_target_ ) {
	cv_cnv_endian_INT( (INT *)_ecnv_target_ );
}

void
cv_cnv_endian_FLOAT( FLOAT *_ecnv_target_ ) {
	cv_cnv_endian_f32( (f32 *)_ecnv_target_ );
}

void
cv_cnv_endian_DOUBLE( DOUBLE *_ecnv_target_ ) {
	cv_cnv_endian_f64( (f64 *)_ecnv_target_ );
}

void
cv_cnv_endian_UCHAR( UCHAR *_ecnv_target_ ) {
	cv_cnv_endian_n8( (n8 *)_ecnv_target_ );
}

void
cv_cnv_endian_USHORT( USHORT *_ecnv_target_ ) {
	cv_cnv_endian_n16( (n16 *)_ecnv_target_ );
}

void
cv_cnv_endian_UINT( UINT *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian_ULONG( ULONG *_ecnv_target_ ) {
	cv_cnv_endian_UINT( (UINT *)_ecnv_target_ );
}

void
cv_cnv_endian_STATUS( STATUS *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian_ADDRESS( ADDRESS *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_e_axis( enum e_axis *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_t_axis( t_axis *_ecnv_target_ ) {
	cv_cnv_endian_enum_e_axis( (enum e_axis *)_ecnv_target_ );
}

void
cv_cnv_endian___u_char( __u_char *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_char( (unsigned char *)_ecnv_target_ );
}

void
cv_cnv_endian___u_short( __u_short *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_short( (unsigned short *)_ecnv_target_ );
}

void
cv_cnv_endian___u_int( __u_int *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian___u_long( __u_long *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian___int8_t( __int8_t *_ecnv_target_ ) {
	cv_cnv_endian_signed_char( (signed char *)_ecnv_target_ );
}

void
cv_cnv_endian___uint8_t( __uint8_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_char( (unsigned char *)_ecnv_target_ );
}

void
cv_cnv_endian___int16_t( __int16_t *_ecnv_target_ ) {
	cv_cnv_endian_signed_short( (signed short *)_ecnv_target_ );
}

void
cv_cnv_endian___uint16_t( __uint16_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_short( (unsigned short *)_ecnv_target_ );
}

void
cv_cnv_endian___int32_t( __int32_t *_ecnv_target_ ) {
	cv_cnv_endian_signed_int( (signed int *)_ecnv_target_ );
}

void
cv_cnv_endian___uint32_t( __uint32_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian___int64_t( __int64_t *_ecnv_target_ ) {
	cv_cnv_endian_signed_long_long( (signed long long *)_ecnv_target_ );
}

void
cv_cnv_endian___uint64_t( __uint64_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long_long( (unsigned long long *)_ecnv_target_ );
}

void
cv_cnv_endian___quad_t( __quad_t *_ecnv_target_ ) {
	cv_cnv_endian_long_long( (long long *)_ecnv_target_ );
}

void
cv_cnv_endian___u_quad_t( __u_quad_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long_long( (unsigned long long *)_ecnv_target_ );
}

void
cv_cnv_endian___dev_t( __dev_t *_ecnv_target_ ) {
	cv_cnv_endian___u_quad_t( (__u_quad_t *)_ecnv_target_ );
}

void
cv_cnv_endian___uid_t( __uid_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian___gid_t( __gid_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian___ino_t( __ino_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian___ino64_t( __ino64_t *_ecnv_target_ ) {
	cv_cnv_endian___u_quad_t( (__u_quad_t *)_ecnv_target_ );
}

void
cv_cnv_endian___mode_t( __mode_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian___nlink_t( __nlink_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian___off_t( __off_t *_ecnv_target_ ) {
	cv_cnv_endian_long( (long *)_ecnv_target_ );
}

void
cv_cnv_endian___off64_t( __off64_t *_ecnv_target_ ) {
	cv_cnv_endian___quad_t( (__quad_t *)_ecnv_target_ );
}

void
cv_cnv_endian___pid_t( __pid_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian___fsid_t( __fsid_t *_ecnv_target_ ) {
	{
		size_t _i37_0;
		for( _i37_0 = 0; _i37_0 < (2); ++_i37_0 ) {
			cv_cnv_endian_int( &_ecnv_target_->__val[_i37_0] );
		}
	}
}

void
cv_cnv_endian___clock_t( __clock_t *_ecnv_target_ ) {
	cv_cnv_endian_long( (long *)_ecnv_target_ );
}

void
cv_cnv_endian___rlim_t( __rlim_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian___rlim64_t( __rlim64_t *_ecnv_target_ ) {
	cv_cnv_endian___u_quad_t( (__u_quad_t *)_ecnv_target_ );
}

void
cv_cnv_endian___id_t( __id_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian___time_t( __time_t *_ecnv_target_ ) {
	cv_cnv_endian_long( (long *)_ecnv_target_ );
}

void
cv_cnv_endian___useconds_t( __useconds_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian___suseconds_t( __suseconds_t *_ecnv_target_ ) {
	cv_cnv_endian_long( (long *)_ecnv_target_ );
}

void
cv_cnv_endian___daddr_t( __daddr_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian___swblk_t( __swblk_t *_ecnv_target_ ) {
	cv_cnv_endian_long( (long *)_ecnv_target_ );
}

void
cv_cnv_endian___key_t( __key_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian___clockid_t( __clockid_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian___timer_t( __timer_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian___blksize_t( __blksize_t *_ecnv_target_ ) {
	cv_cnv_endian_long( (long *)_ecnv_target_ );
}

void
cv_cnv_endian___blkcnt_t( __blkcnt_t *_ecnv_target_ ) {
	cv_cnv_endian_long( (long *)_ecnv_target_ );
}

void
cv_cnv_endian___blkcnt64_t( __blkcnt64_t *_ecnv_target_ ) {
	cv_cnv_endian___quad_t( (__quad_t *)_ecnv_target_ );
}

void
cv_cnv_endian___fsblkcnt_t( __fsblkcnt_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian___fsblkcnt64_t( __fsblkcnt64_t *_ecnv_target_ ) {
	cv_cnv_endian___u_quad_t( (__u_quad_t *)_ecnv_target_ );
}

void
cv_cnv_endian___fsfilcnt_t( __fsfilcnt_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian___fsfilcnt64_t( __fsfilcnt64_t *_ecnv_target_ ) {
	cv_cnv_endian___u_quad_t( (__u_quad_t *)_ecnv_target_ );
}

void
cv_cnv_endian___ssize_t( __ssize_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian___loff_t( __loff_t *_ecnv_target_ ) {
	cv_cnv_endian___off64_t( (__off64_t *)_ecnv_target_ );
}

void
cv_cnv_endian___qaddr_t( __qaddr_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian___caddr_t( __caddr_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian___intptr_t( __intptr_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian___socklen_t( __socklen_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian_FILE( FILE *_ecnv_target_ ) {
	cv_cnv_endian_struct__IO_FILE( (struct _IO_FILE *)_ecnv_target_ );
}

void
cv_cnv_endian___FILE( __FILE *_ecnv_target_ ) {
	cv_cnv_endian_struct__IO_FILE( (struct _IO_FILE *)_ecnv_target_ );
}

void
cv_cnv_endian___mbstate_t( __mbstate_t *_ecnv_target_ ) {
	cv_cnv_endian_int( &_ecnv_target_->__count );
	}

void
cv_cnv_endian__G_fpos_t( _G_fpos_t *_ecnv_target_ ) {
	cv_cnv_endian___off_t( &_ecnv_target_->__pos );
	cv_cnv_endian___mbstate_t( &_ecnv_target_->__state );
}

void
cv_cnv_endian__G_fpos64_t( _G_fpos64_t *_ecnv_target_ ) {
	cv_cnv_endian___off64_t( &_ecnv_target_->__pos );
	cv_cnv_endian___mbstate_t( &_ecnv_target_->__state );
}

void
cv_cnv_endian__G_int16_t( _G_int16_t *_ecnv_target_ ) {
	cv_cnv_endian_short( (short *)_ecnv_target_ );
}

void
cv_cnv_endian__G_int32_t( _G_int32_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian__G_uint16_t( _G_uint16_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_short( (unsigned short *)_ecnv_target_ );
}

void
cv_cnv_endian__G_uint32_t( _G_uint32_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian___gnuc_va_list( __gnuc_va_list *_ecnv_target_ ) {
	cv_cnv_endian___builtin_va_list( (__builtin_va_list *)_ecnv_target_ );
}

void
cv_cnv_endian__IO_lock_t( _IO_lock_t *_ecnv_target_ ) {
	cv_cnv_endian_void( (void *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__IO_marker( struct _IO_marker *_ecnv_target_ )
{
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_next );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_sbuf );
	cv_cnv_endian_int( &_ecnv_target_->_pos );
}

void
cv_cnv_endian_enum___codecvt_result( enum __codecvt_result *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_struct__IO_FILE( struct _IO_FILE *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->_flags );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_IO_read_ptr );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_IO_read_end );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_IO_read_base );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_IO_write_base );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_IO_write_ptr );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_IO_write_end );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_IO_buf_base );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_IO_buf_end );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_IO_save_base );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_IO_backup_base );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_IO_save_end );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_markers );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_chain );
	cv_cnv_endian_int( &_ecnv_target_->_fileno );
	cv_cnv_endian_int( &_ecnv_target_->_flags2 );
	cv_cnv_endian___off_t( &_ecnv_target_->_old_offset );
	cv_cnv_endian_unsigned_short( &_ecnv_target_->_cur_column );
	cv_cnv_endian_signed_char( &_ecnv_target_->_vtable_offset );
	{
		size_t _i38_0;
		for( _i38_0 = 0; _i38_0 < (1); ++_i38_0 ) {
			cv_cnv_endian_char( &_ecnv_target_->_shortbuf[_i38_0] );
		}
	}
	cv_cnv_endian_unsigned_long( &_ecnv_target_->_lock );
	cv_cnv_endian___off64_t( &_ecnv_target_->_offset );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->__pad1 );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->__pad2 );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->__pad3 );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->__pad4 );
	cv_cnv_endian_size_t( &_ecnv_target_->__pad5 );
	cv_cnv_endian_int( &_ecnv_target_->_mode );
	{
		size_t _i39_0;
		for( _i39_0 = 0; _i39_0 < (15 * sizeof (int) - 4 * sizeof (void *) - sizeof (size_t)); ++_i39_0 ) {
			cv_cnv_endian_char( &_ecnv_target_->_unused2[_i39_0] );
		}
	}
}

void
cv_cnv_endian__IO_FILE( _IO_FILE *_ecnv_target_ ) {
	cv_cnv_endian_struct__IO_FILE( (struct _IO_FILE *)_ecnv_target_ );
}

void
cv_cnv_endian_va_list( va_list *_ecnv_target_ ) {
	cv_cnv_endian___gnuc_va_list( (__gnuc_va_list *)_ecnv_target_ );
}

void
cv_cnv_endian_off_t( off_t *_ecnv_target_ ) {
	cv_cnv_endian___off_t( (__off_t *)_ecnv_target_ );
}

void
cv_cnv_endian_ssize_t( ssize_t *_ecnv_target_ ) {
	cv_cnv_endian___ssize_t( (__ssize_t *)_ecnv_target_ );
}

void
cv_cnv_endian_fpos_t( fpos_t *_ecnv_target_ ) {
	cv_cnv_endian__G_fpos_t( (_G_fpos_t *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_e_fopen_mode( enum e_fopen_mode *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_t_fopen_mode( t_fopen_mode *_ecnv_target_ ) {
	cv_cnv_endian_enum_e_fopen_mode( (enum e_fopen_mode *)_ecnv_target_ );
}

void
cv_cnv_endian_datavalue( datavalue *_ecnv_target_ ) {
	cv_cnv_endian_float( (float *)_ecnv_target_ );
}

void
cv_cnv_endian_SeqCfgSysCfgInfo( SeqCfgSysCfgInfo *_ecnv_target_ ) {
	cv_cnv_endian_n32( &_ecnv_target_->sscType );
	cv_cnv_endian_n32( &_ecnv_target_->ptxCapable );
	cv_cnv_endian_n32( &_ecnv_target_->fieldStrength );
	cv_cnv_endian_n32( &_ecnv_target_->rfAmpType );
	cv_cnv_endian_n32( &_ecnv_target_->receiverType );
}

void
cv_cnv_endian_SeqCfgSeqInfo( SeqCfgSeqInfo *_ecnv_target_ ) {
	cv_cnv_endian_s32( &_ecnv_target_->seqId );
	cv_cnv_endian_n32( &_ecnv_target_->seqType );
	cv_cnv_endian_s32( &_ecnv_target_->duplicateSeqId );
	cv_cnv_endian_s32( &_ecnv_target_->sspSeqId );
	cv_cnv_endian_s32( &_ecnv_target_->rfGroupId );
	cv_cnv_endian_s32( &_ecnv_target_->rfGroupTxChannel );
	cv_cnv_endian_n32( &_ecnv_target_->coreId );
	cv_cnv_endian_s32( &_ecnv_target_->coreRfChannel );
}

void
cv_cnv_endian_SeqCfgCoreInfo( SeqCfgCoreInfo *_ecnv_target_ ) {
	cv_cnv_endian_s32( &_ecnv_target_->coreId );
	cv_cnv_endian_n32( &_ecnv_target_->coreType );
	{
		size_t _i40_0;
		for( _i40_0 = 0; _i40_0 < (SEQ_CFG_MAX_RF_GROUPS); ++_i40_0 ) {
			cv_cnv_endian_s32( &_ecnv_target_->requiredPhysicalTxId[_i40_0] );
		}
	}
	cv_cnv_endian_n32( &_ecnv_target_->numSeqs );
	{
		size_t _i41_0;
		for( _i41_0 = 0; _i41_0 < (SEQ_CFG_MAX_CORE_SEQS); ++_i41_0 ) {
			cv_cnv_endian_n32( &_ecnv_target_->seqs[_i41_0] );
		}
	}
}

void
cv_cnv_endian_SeqCfgRfTxInfo( SeqCfgRfTxInfo *_ecnv_target_ ) {
	cv_cnv_endian_n32( &_ecnv_target_->txAmp );
	cv_cnv_endian_n32( &_ecnv_target_->txCoilType );
	cv_cnv_endian_n32( &_ecnv_target_->txNucleus );
	cv_cnv_endian_n32( &_ecnv_target_->txChannels );
}

void
cv_cnv_endian_SeqCfgRfGroupInfo( SeqCfgRfGroupInfo *_ecnv_target_ ) {
	cv_cnv_endian_n32( &_ecnv_target_->rfGroupId );
	cv_cnv_endian_n32( &_ecnv_target_->numAppTxChannels );
	cv_cnv_endian_n32( &_ecnv_target_->txSeqTypes );
	cv_cnv_endian_n32( &_ecnv_target_->rxFlag );
	cv_cnv_endian_n32( &_ecnv_target_->rxSeqTypes );
	cv_cnv_endian_n32( &_ecnv_target_->mode );
	cv_cnv_endian_SeqCfgRfTxInfo( &_ecnv_target_->txInfo );
}

void
cv_cnv_endian_SeqCfgInfo( SeqCfgInfo *_ecnv_target_ ) {
	cv_cnv_endian_s32( &_ecnv_target_->valid );
	cv_cnv_endian_n32( &_ecnv_target_->debugOptions );
	cv_cnv_endian_n32( &_ecnv_target_->numRfGroups );
	cv_cnv_endian_n32( &_ecnv_target_->numCores );
	cv_cnv_endian_n32( &_ecnv_target_->numAppSeqs );
	cv_cnv_endian_n32( &_ecnv_target_->numSeqs );
	cv_cnv_endian_SeqCfgSysCfgInfo( &_ecnv_target_->sysCfg );
	{
		size_t _i42_0;
		for( _i42_0 = 0; _i42_0 < (SEQ_CFG_MAX_RF_GROUPS); ++_i42_0 ) {
			cv_cnv_endian_SeqCfgRfGroupInfo( &_ecnv_target_->rfGroups[_i42_0] );
		}
	}
	{
		size_t _i43_0;
		for( _i43_0 = 0; _i43_0 < (SEQ_CFG_MAX_CORES); ++_i43_0 ) {
			cv_cnv_endian_SeqCfgCoreInfo( &_ecnv_target_->cores[_i43_0] );
		}
	}
	{
		size_t _i44_0;
		for( _i44_0 = 0; _i44_0 < (SEQ_CFG_MAX_SEQ_IDS); ++_i44_0 ) {
			cv_cnv_endian_SeqCfgSeqInfo( &_ecnv_target_->seqs[_i44_0] );
		}
	}
}

void
cv_cnv_endian_struct_SeqType( struct SeqType *_ecnv_target_ )
{
	cv_cnv_endian_n32( &_ecnv_target_->seqID );
	cv_cnv_endian_n32( &_ecnv_target_->seqOpt );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->pName );
}

void
cv_cnv_endian_SeqType( SeqType *_ecnv_target_ ) {
	cv_cnv_endian_struct_SeqType( (struct SeqType *)_ecnv_target_ );
}

void
cv_cnv_endian_TYPDAB_PACKETS( TYPDAB_PACKETS *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_TYPACQ_PASS( TYPACQ_PASS *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_SeqData( SeqData *_ecnv_target_ ) {
	cv_cnv_endian_SeqType( (SeqType *)_ecnv_target_ );
}

void
cv_cnv_endian_WF_HW_WAVEFORM_PTR( WF_HW_WAVEFORM_PTR *_ecnv_target_ ) {
	cv_cnv_endian_long( (long *)_ecnv_target_ );
}

void
cv_cnv_endian_WF_HW_INSTR_PTR( WF_HW_INSTR_PTR *_ecnv_target_ ) {
	cv_cnv_endian_long( (long *)_ecnv_target_ );
}

void
cv_cnv_endian_WF_PULSE_FORWARD_ADDR( WF_PULSE_FORWARD_ADDR *_ecnv_target_ ) {
	cv_cnv_endian_ADDRESS( (ADDRESS *)_ecnv_target_ );
}

void
cv_cnv_endian_WF_INSTR_PTR( WF_INSTR_PTR *_ecnv_target_ ) {
	cv_cnv_endian_ADDRESS( (ADDRESS *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_INST_NODE( struct INST_NODE *_ecnv_target_ )
{
	cv_cnv_endian_unsigned_long( &_ecnv_target_->next );
	cv_cnv_endian_WF_HW_INSTR_PTR( &_ecnv_target_->wf_instr_ptr );
	cv_cnv_endian_long( &_ecnv_target_->amplitude );
	cv_cnv_endian_long( &_ecnv_target_->period );
	cv_cnv_endian_long( &_ecnv_target_->start );
	cv_cnv_endian_long( &_ecnv_target_->end );
	cv_cnv_endian_long( &_ecnv_target_->entry_group );
	cv_cnv_endian_WF_PULSE_FORWARD_ADDR( &_ecnv_target_->pulse_hdr );
	{
		size_t _i45_0;
		for( _i45_0 = 0; _i45_0 < (SEQ_CFG_MAX_CORES); ++_i45_0 ) {
			cv_cnv_endian_WF_HW_INSTR_PTR( &_ecnv_target_->wf_instr_ptr_secssp[_i45_0] );
		}
	}
	cv_cnv_endian_int( &_ecnv_target_->num_iters );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->ampl_iters );
}

void
cv_cnv_endian_WF_INSTR_HDR( WF_INSTR_HDR *_ecnv_target_ ) {
	cv_cnv_endian_struct_INST_NODE( (struct INST_NODE *)_ecnv_target_ );
}

void
cv_cnv_endian_CONST_EXT( CONST_EXT *_ecnv_target_ ) {
	cv_cnv_endian_short( &_ecnv_target_->amplitude );
}

void
cv_cnv_endian_HADAMARD_EXT( HADAMARD_EXT *_ecnv_target_ ) {
	cv_cnv_endian_short( &_ecnv_target_->amplitude );
	cv_cnv_endian_float( &_ecnv_target_->separation );
	cv_cnv_endian_float( &_ecnv_target_->nsinc_cycles );
	cv_cnv_endian_float( &_ecnv_target_->alpha );
}

void
cv_cnv_endian_RAMP_EXT( RAMP_EXT *_ecnv_target_ ) {
	cv_cnv_endian_short( &_ecnv_target_->start_amplitude );
	cv_cnv_endian_short( &_ecnv_target_->end_amplitude );
}

void
cv_cnv_endian_SINC_EXT( SINC_EXT *_ecnv_target_ ) {
	cv_cnv_endian_short( &_ecnv_target_->amplitude );
	cv_cnv_endian_float( &_ecnv_target_->nsinc_cycles );
	cv_cnv_endian_float( &_ecnv_target_->alpha );
}

void
cv_cnv_endian_SINUSOID_EXT( SINUSOID_EXT *_ecnv_target_ ) {
	cv_cnv_endian_short( &_ecnv_target_->amplitude );
	cv_cnv_endian_float( &_ecnv_target_->start_phase );
	cv_cnv_endian_float( &_ecnv_target_->phase_length );
	cv_cnv_endian_short( &_ecnv_target_->offset );
}

void
cv_cnv_endian_WF_PULSE_EXT( WF_PULSE_EXT *_ecnv_target_ ) {
}

void
cv_cnv_endian_WF_PULSE_TYPES( WF_PULSE_TYPES *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_WF_PGMTAG( WF_PGMTAG *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_WF_PGMREUSE( WF_PGMREUSE *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_struct_PULSE( struct PULSE *_ecnv_target_ )
{
	cv_cnv_endian_unsigned_long( &_ecnv_target_->pulsename );
	cv_cnv_endian_long( &_ecnv_target_->ninsts );
	cv_cnv_endian_WF_HW_WAVEFORM_PTR( &_ecnv_target_->wave_addr );
	cv_cnv_endian_int( &_ecnv_target_->board_type );
	cv_cnv_endian_WF_PGMREUSE( &_ecnv_target_->reusep );
	cv_cnv_endian_WF_PGMTAG( &_ecnv_target_->tag );
	cv_cnv_endian_long( &_ecnv_target_->addtag );
	cv_cnv_endian_int( &_ecnv_target_->id );
	cv_cnv_endian_long( &_ecnv_target_->ctrlfield );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->inst_hdr_tail );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->inst_hdr_head );
	cv_cnv_endian_WF_PROCESSOR( &_ecnv_target_->wavegen_type );
	cv_cnv_endian_WF_PULSE_TYPES( &_ecnv_target_->type );
	cv_cnv_endian_short( &_ecnv_target_->resolution );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->assoc_pulse );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->ext );
	cv_cnv_endian_int( &_ecnv_target_->rfgroup );
	cv_cnv_endian_int( &_ecnv_target_->ptx_flag );
	cv_cnv_endian_int( &_ecnv_target_->seq_id );
	cv_cnv_endian_int( &_ecnv_target_->rx_flag );
	{
		size_t _i46_0;
		for( _i46_0 = 0; _i46_0 < (SEQ_CFG_MAX_CORES); ++_i46_0 ) {
			cv_cnv_endian_WF_HW_WAVEFORM_PTR( &_ecnv_target_->wave_addr_secssp[_i46_0] );
		}
	}
}

void
cv_cnv_endian_WF_PULSE( WF_PULSE *_ecnv_target_ ) {
	cv_cnv_endian_struct_PULSE( (struct PULSE *)_ecnv_target_ );
}

void
cv_cnv_endian_WF_PULSE_ADDR( WF_PULSE_ADDR *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_INST_QUEUE_NODE( struct INST_QUEUE_NODE *_ecnv_target_ )
{
	cv_cnv_endian_unsigned_long( &_ecnv_target_->instr );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->next );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->new_queue );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->last_queue );
}

void
cv_cnv_endian_WF_INSTR_QUEUE( WF_INSTR_QUEUE *_ecnv_target_ ) {
	cv_cnv_endian_struct_INST_QUEUE_NODE( (struct INST_QUEUE_NODE *)_ecnv_target_ );
}

void
cv_cnv_endian_SEQUENCE_ENTRIES( SEQUENCE_ENTRIES *_ecnv_target_ ) {
	{
		size_t _i47_0;
		for( _i47_0 = 0; _i47_0 < (SEQ_CFG_MAX_SEQ_IDS); ++_i47_0 ) {
			cv_cnv_endian_long( (long *)&((*_ecnv_target_)[_i47_0]) );
		}
	}
}

void
cv_cnv_endian_struct_ENTRY_PT_NODE( struct ENTRY_PT_NODE *_ecnv_target_ )
{
	cv_cnv_endian_WF_PULSE_ADDR( &_ecnv_target_->ssp_pulse );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->entry_addresses );
	cv_cnv_endian_long( &_ecnv_target_->time );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->next );
}

void
cv_cnv_endian_SEQUENCE_LIST( SEQUENCE_LIST *_ecnv_target_ ) {
	cv_cnv_endian_struct_ENTRY_PT_NODE( (struct ENTRY_PT_NODE *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_rbw_update_type( enum rbw_update_type *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_RBW_UPDATE_TYPE( RBW_UPDATE_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_enum_rbw_update_type( (enum rbw_update_type *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_filter_block_type( enum filter_block_type *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_FILTER_BLOCK_TYPE( FILTER_BLOCK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_enum_filter_block_type( (enum filter_block_type *)_ecnv_target_ );
}

void
cv_cnv_endian_FILTER_INFO( FILTER_INFO *_ecnv_target_ ) {
	cv_cnv_endian_float( &_ecnv_target_->decimation );
	cv_cnv_endian_int( &_ecnv_target_->tdaq );
	cv_cnv_endian_float( &_ecnv_target_->bw );
	cv_cnv_endian_float( &_ecnv_target_->tsp );
	cv_cnv_endian_int( &_ecnv_target_->fslot );
	cv_cnv_endian_int( &_ecnv_target_->outputs );
	cv_cnv_endian_int( &_ecnv_target_->prefills );
	cv_cnv_endian_int( &_ecnv_target_->taps );
}

void
cv_cnv_endian_HOEC_CAL_INFO( HOEC_CAL_INFO *_ecnv_target_ ) {
	cv_cnv_endian_int( &_ecnv_target_->fit_order );
	cv_cnv_endian_int( &_ecnv_target_->total_bases_per_axis );
	{
		size_t _i48_0, _i48_1;
		for( _i48_0 = 0; _i48_0 < (3); ++_i48_0 )
		for( _i48_1 = 0; _i48_1 < (56); ++_i48_1 ) {
			cv_cnv_endian_int( &_ecnv_target_->num_terms[_i48_0][_i48_1] );
		}
	}
	{
		size_t _i49_0, _i49_1, _i49_2;
		for( _i49_0 = 0; _i49_0 < (3); ++_i49_0 )
		for( _i49_1 = 0; _i49_1 < (56); ++_i49_1 )
		for( _i49_2 = 0; _i49_2 < (6); ++_i49_2 ) {
			cv_cnv_endian_float( &_ecnv_target_->alpha[_i49_0][_i49_1][_i49_2] );
		}
	}
	{
		size_t _i50_0, _i50_1, _i50_2;
		for( _i50_0 = 0; _i50_0 < (3); ++_i50_0 )
		for( _i50_1 = 0; _i50_1 < (56); ++_i50_1 )
		for( _i50_2 = 0; _i50_2 < (6); ++_i50_2 ) {
			cv_cnv_endian_float( &_ecnv_target_->tau[_i50_0][_i50_1][_i50_2] );
		}
	}
	{
		size_t _i51_0, _i51_1;
		for( _i51_0 = 0; _i51_0 < (3); ++_i51_0 )
		for( _i51_1 = 0; _i51_1 < (56); ++_i51_1 ) {
			cv_cnv_endian_int( &_ecnv_target_->termIndex2xyzOrderMapping[_i51_0][_i51_1] );
		}
	}
	{
		size_t _i52_0, _i52_1, _i52_2;
		for( _i52_0 = 0; _i52_0 < (6); ++_i52_0 )
		for( _i52_1 = 0; _i52_1 < (6); ++_i52_1 )
		for( _i52_2 = 0; _i52_2 < (6); ++_i52_2 ) {
			cv_cnv_endian_int( &_ecnv_target_->xyzOrder2termIndexMapping[_i52_0][_i52_1][_i52_2] );
		}
	}
}

void
cv_cnv_endian_RDB_HOEC_BASES_TYPE( RDB_HOEC_BASES_TYPE *_ecnv_target_ ) {
	{
		size_t _i53_0, _i53_1;
		for( _i53_0 = 0; _i53_0 < (56); ++_i53_0 )
		for( _i53_1 = 0; _i53_1 < (3); ++_i53_1 ) {
			cv_cnv_endian_float( &_ecnv_target_->hoec_coef[_i53_0][_i53_1] );
		}
	}
	{
		size_t _i54_0;
		for( _i54_0 = 0; _i54_0 < (56); ++_i54_0 ) {
			cv_cnv_endian_int( &_ecnv_target_->hoec_xorder[_i54_0] );
		}
	}
	{
		size_t _i55_0;
		for( _i55_0 = 0; _i55_0 < (56); ++_i55_0 ) {
			cv_cnv_endian_int( &_ecnv_target_->hoec_yorder[_i55_0] );
		}
	}
	{
		size_t _i56_0;
		for( _i56_0 = 0; _i56_0 < (56); ++_i56_0 ) {
			cv_cnv_endian_int( &_ecnv_target_->hoec_zorder[_i56_0] );
		}
	}
}

void
cv_cnv_endian_PHYS_GRAD( PHYS_GRAD *_ecnv_target_ ) {
	cv_cnv_endian_int( &_ecnv_target_->xfull );
	cv_cnv_endian_int( &_ecnv_target_->yfull );
	cv_cnv_endian_int( &_ecnv_target_->zfull );
	cv_cnv_endian_float( &_ecnv_target_->xfs );
	cv_cnv_endian_float( &_ecnv_target_->yfs );
	cv_cnv_endian_float( &_ecnv_target_->zfs );
	cv_cnv_endian_int( &_ecnv_target_->xrt );
	cv_cnv_endian_int( &_ecnv_target_->yrt );
	cv_cnv_endian_int( &_ecnv_target_->zrt );
	cv_cnv_endian_int( &_ecnv_target_->xft );
	cv_cnv_endian_int( &_ecnv_target_->yft );
	cv_cnv_endian_int( &_ecnv_target_->zft );
	cv_cnv_endian_float( &_ecnv_target_->xcc );
	cv_cnv_endian_float( &_ecnv_target_->ycc );
	cv_cnv_endian_float( &_ecnv_target_->zcc );
	cv_cnv_endian_float( &_ecnv_target_->xbeta );
	cv_cnv_endian_float( &_ecnv_target_->ybeta );
	cv_cnv_endian_float( &_ecnv_target_->zbeta );
	cv_cnv_endian_float( &_ecnv_target_->xirms );
	cv_cnv_endian_float( &_ecnv_target_->yirms );
	cv_cnv_endian_float( &_ecnv_target_->zirms );
	cv_cnv_endian_float( &_ecnv_target_->xipeak );
	cv_cnv_endian_float( &_ecnv_target_->yipeak );
	cv_cnv_endian_float( &_ecnv_target_->zipeak );
	cv_cnv_endian_float( &_ecnv_target_->xamptran );
	cv_cnv_endian_float( &_ecnv_target_->yamptran );
	cv_cnv_endian_float( &_ecnv_target_->zamptran );
	cv_cnv_endian_float( &_ecnv_target_->xiavrgabs );
	cv_cnv_endian_float( &_ecnv_target_->yiavrgabs );
	cv_cnv_endian_float( &_ecnv_target_->ziavrgabs );
	cv_cnv_endian_float( &_ecnv_target_->xirmspos );
	cv_cnv_endian_float( &_ecnv_target_->yirmspos );
	cv_cnv_endian_float( &_ecnv_target_->zirmspos );
	cv_cnv_endian_float( &_ecnv_target_->xirmsneg );
	cv_cnv_endian_float( &_ecnv_target_->yirmsneg );
	cv_cnv_endian_float( &_ecnv_target_->zirmsneg );
	cv_cnv_endian_float( &_ecnv_target_->xpwmdc );
	cv_cnv_endian_float( &_ecnv_target_->ypwmdc );
	cv_cnv_endian_float( &_ecnv_target_->zpwmdc );
}

void
cv_cnv_endian_t_xact( t_xact *_ecnv_target_ ) {
	cv_cnv_endian_int( &_ecnv_target_->x );
	cv_cnv_endian_int( &_ecnv_target_->xy );
	cv_cnv_endian_int( &_ecnv_target_->xz );
	cv_cnv_endian_int( &_ecnv_target_->xyz );
}

void
cv_cnv_endian_t_yact( t_yact *_ecnv_target_ ) {
	cv_cnv_endian_int( &_ecnv_target_->y );
	cv_cnv_endian_int( &_ecnv_target_->xy );
	cv_cnv_endian_int( &_ecnv_target_->yz );
	cv_cnv_endian_int( &_ecnv_target_->xyz );
}

void
cv_cnv_endian_t_zact( t_zact *_ecnv_target_ ) {
	cv_cnv_endian_int( &_ecnv_target_->z );
	cv_cnv_endian_int( &_ecnv_target_->xz );
	cv_cnv_endian_int( &_ecnv_target_->yz );
	cv_cnv_endian_int( &_ecnv_target_->xyz );
}

void
cv_cnv_endian_ramp_t( ramp_t *_ecnv_target_ ) {
	cv_cnv_endian_int( &_ecnv_target_->xrt );
	cv_cnv_endian_int( &_ecnv_target_->yrt );
	cv_cnv_endian_int( &_ecnv_target_->zrt );
	cv_cnv_endian_int( &_ecnv_target_->xft );
	cv_cnv_endian_int( &_ecnv_target_->yft );
	cv_cnv_endian_int( &_ecnv_target_->zft );
}

void
cv_cnv_endian_LOG_GRAD( LOG_GRAD *_ecnv_target_ ) {
	cv_cnv_endian_int( &_ecnv_target_->xrt );
	cv_cnv_endian_int( &_ecnv_target_->yrt );
	cv_cnv_endian_int( &_ecnv_target_->zrt );
	cv_cnv_endian_int( &_ecnv_target_->xft );
	cv_cnv_endian_int( &_ecnv_target_->yft );
	cv_cnv_endian_int( &_ecnv_target_->zft );
	cv_cnv_endian_ramp_t( &_ecnv_target_->opt );
	cv_cnv_endian_t_xact( &_ecnv_target_->xrta );
	cv_cnv_endian_t_yact( &_ecnv_target_->yrta );
	cv_cnv_endian_t_zact( &_ecnv_target_->zrta );
	cv_cnv_endian_t_xact( &_ecnv_target_->xfta );
	cv_cnv_endian_t_yact( &_ecnv_target_->yfta );
	cv_cnv_endian_t_zact( &_ecnv_target_->zfta );
	cv_cnv_endian_float( &_ecnv_target_->xbeta );
	cv_cnv_endian_float( &_ecnv_target_->ybeta );
	cv_cnv_endian_float( &_ecnv_target_->zbeta );
	cv_cnv_endian_float( &_ecnv_target_->tx_xyz );
	cv_cnv_endian_float( &_ecnv_target_->ty_xyz );
	cv_cnv_endian_float( &_ecnv_target_->tz_xyz );
	cv_cnv_endian_float( &_ecnv_target_->tx_xy );
	cv_cnv_endian_float( &_ecnv_target_->tx_xz );
	cv_cnv_endian_float( &_ecnv_target_->ty_xy );
	cv_cnv_endian_float( &_ecnv_target_->ty_yz );
	cv_cnv_endian_float( &_ecnv_target_->tz_xz );
	cv_cnv_endian_float( &_ecnv_target_->tz_yz );
	cv_cnv_endian_float( &_ecnv_target_->tx );
	cv_cnv_endian_float( &_ecnv_target_->ty );
	cv_cnv_endian_float( &_ecnv_target_->tz );
	cv_cnv_endian_float( &_ecnv_target_->xfs );
	cv_cnv_endian_float( &_ecnv_target_->yfs );
	cv_cnv_endian_float( &_ecnv_target_->zfs );
	cv_cnv_endian_float( &_ecnv_target_->xirms );
	cv_cnv_endian_float( &_ecnv_target_->yirms );
	cv_cnv_endian_float( &_ecnv_target_->zirms );
	cv_cnv_endian_float( &_ecnv_target_->xipeak );
	cv_cnv_endian_float( &_ecnv_target_->yipeak );
	cv_cnv_endian_float( &_ecnv_target_->zipeak );
	cv_cnv_endian_float( &_ecnv_target_->xamptran );
	cv_cnv_endian_float( &_ecnv_target_->yamptran );
	cv_cnv_endian_float( &_ecnv_target_->zamptran );
	cv_cnv_endian_float( &_ecnv_target_->xiavrgabs );
	cv_cnv_endian_float( &_ecnv_target_->yiavrgabs );
	cv_cnv_endian_float( &_ecnv_target_->ziavrgabs );
	cv_cnv_endian_float( &_ecnv_target_->xirmspos );
	cv_cnv_endian_float( &_ecnv_target_->yirmspos );
	cv_cnv_endian_float( &_ecnv_target_->zirmspos );
	cv_cnv_endian_float( &_ecnv_target_->xirmsneg );
	cv_cnv_endian_float( &_ecnv_target_->yirmsneg );
	cv_cnv_endian_float( &_ecnv_target_->zirmsneg );
	cv_cnv_endian_float( &_ecnv_target_->xpwmdc );
	cv_cnv_endian_float( &_ecnv_target_->ypwmdc );
	cv_cnv_endian_float( &_ecnv_target_->zpwmdc );
	cv_cnv_endian_float( &_ecnv_target_->scale_1axis_risetime );
	cv_cnv_endian_float( &_ecnv_target_->scale_2axis_risetime );
	cv_cnv_endian_float( &_ecnv_target_->scale_3axis_risetime );
}

void
cv_cnv_endian_OPT_GRAD_INPUT( OPT_GRAD_INPUT *_ecnv_target_ ) {
	cv_cnv_endian_float( &_ecnv_target_->xfs );
	cv_cnv_endian_float( &_ecnv_target_->yfs );
	cv_cnv_endian_float( &_ecnv_target_->zfs );
	cv_cnv_endian_int( &_ecnv_target_->xrt );
	cv_cnv_endian_int( &_ecnv_target_->yrt );
	cv_cnv_endian_int( &_ecnv_target_->zrt );
	cv_cnv_endian_float( &_ecnv_target_->xbeta );
	cv_cnv_endian_float( &_ecnv_target_->ybeta );
	cv_cnv_endian_float( &_ecnv_target_->zbeta );
	cv_cnv_endian_float( &_ecnv_target_->xfov );
	cv_cnv_endian_float( &_ecnv_target_->yfov );
	cv_cnv_endian_int( &_ecnv_target_->xres );
	cv_cnv_endian_int( &_ecnv_target_->yres );
	cv_cnv_endian_int( &_ecnv_target_->ileaves );
	cv_cnv_endian_float( &_ecnv_target_->xdis );
	cv_cnv_endian_float( &_ecnv_target_->ydis );
	cv_cnv_endian_float( &_ecnv_target_->zdis );
	cv_cnv_endian_float( &_ecnv_target_->tsp );
	cv_cnv_endian_int( &_ecnv_target_->osamps );
	cv_cnv_endian_float( &_ecnv_target_->fbhw );
	cv_cnv_endian_int( &_ecnv_target_->vvp );
	cv_cnv_endian_float( &_ecnv_target_->pnsf );
	cv_cnv_endian_float( &_ecnv_target_->taratio );
	cv_cnv_endian_float( &_ecnv_target_->zarea );
}

void
cv_cnv_endian_OPT_GRAD_PARAMS( OPT_GRAD_PARAMS *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( &_ecnv_target_->agxw );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->pwgxw );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->pwgxwa );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->agyb );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->pwgyb );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->pwgyba );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->agzb );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->pwgzb );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->pwgzba );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->frsize );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->pwsamp );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->pwxgap );
}

void
cv_cnv_endian_clock_t( clock_t *_ecnv_target_ ) {
	cv_cnv_endian___clock_t( (__clock_t *)_ecnv_target_ );
}

void
cv_cnv_endian_time_t( time_t *_ecnv_target_ ) {
	cv_cnv_endian___time_t( (__time_t *)_ecnv_target_ );
}

void
cv_cnv_endian_clockid_t( clockid_t *_ecnv_target_ ) {
	cv_cnv_endian___clockid_t( (__clockid_t *)_ecnv_target_ );
}

void
cv_cnv_endian_timer_t( timer_t *_ecnv_target_ ) {
	cv_cnv_endian___timer_t( (__timer_t *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_timespec( struct timespec *_ecnv_target_ )
{
	cv_cnv_endian___time_t( &_ecnv_target_->tv_sec );
	cv_cnv_endian_long( &_ecnv_target_->tv_nsec );
}

void
cv_cnv_endian_struct_tm( struct tm *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->tm_sec );
	cv_cnv_endian_int( &_ecnv_target_->tm_min );
	cv_cnv_endian_int( &_ecnv_target_->tm_hour );
	cv_cnv_endian_int( &_ecnv_target_->tm_mday );
	cv_cnv_endian_int( &_ecnv_target_->tm_mon );
	cv_cnv_endian_int( &_ecnv_target_->tm_year );
	cv_cnv_endian_int( &_ecnv_target_->tm_wday );
	cv_cnv_endian_int( &_ecnv_target_->tm_yday );
	cv_cnv_endian_int( &_ecnv_target_->tm_isdst );
	cv_cnv_endian_long( &_ecnv_target_->tm_gmtoff );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->tm_zone );
}

void
cv_cnv_endian_struct_itimerspec( struct itimerspec *_ecnv_target_ )
{
	cv_cnv_endian_struct_timespec( &_ecnv_target_->it_interval );
	cv_cnv_endian_struct_timespec( &_ecnv_target_->it_value );
}

void
cv_cnv_endian_pid_t( pid_t *_ecnv_target_ ) {
	cv_cnv_endian___pid_t( (__pid_t *)_ecnv_target_ );
}

void
cv_cnv_endian_struct___locale_struct( struct __locale_struct *_ecnv_target_ )
{
	{
		size_t _i57_0;
		for( _i57_0 = 0; _i57_0 < (13); ++_i57_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->__locales[_i57_0] );
		}
	}
	cv_cnv_endian_unsigned_long( &_ecnv_target_->__ctype_b );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->__ctype_tolower );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->__ctype_toupper );
	{
		size_t _i58_0;
		for( _i58_0 = 0; _i58_0 < (13); ++_i58_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->__names[_i58_0] );
		}
	}
}

void
cv_cnv_endian___locale_t( __locale_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian_locale_t( locale_t *_ecnv_target_ ) {
	cv_cnv_endian___locale_t( (__locale_t *)_ecnv_target_ );
}

void
cv_cnv_endian_GEtimespec( GEtimespec *_ecnv_target_ ) {
	cv_cnv_endian_struct_timespec( (struct timespec *)_ecnv_target_ );
}

void
cv_cnv_endian_dbkey_exam_type( dbkey_exam_type *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_short( (unsigned short *)_ecnv_target_ );
}

void
cv_cnv_endian_dbkey_magic_type( dbkey_magic_type *_ecnv_target_ ) {
	cv_cnv_endian_short( (short *)_ecnv_target_ );
}

void
cv_cnv_endian_dbkey_series_type( dbkey_series_type *_ecnv_target_ ) {
	cv_cnv_endian_short( (short *)_ecnv_target_ );
}

void
cv_cnv_endian_dbkey_image_type( dbkey_image_type *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian_DbKey( DbKey *_ecnv_target_ ) {
	{
		size_t _i59_0;
		for( _i59_0 = 0; _i59_0 < (4); ++_i59_0 ) {
			cv_cnv_endian_char( &_ecnv_target_->su_id[_i59_0] );
		}
	}
	cv_cnv_endian_dbkey_magic_type( &_ecnv_target_->mg_no );
	cv_cnv_endian_dbkey_exam_type( &_ecnv_target_->ex_no );
	cv_cnv_endian_dbkey_series_type( &_ecnv_target_->se_no );
	cv_cnv_endian_dbkey_image_type( &_ecnv_target_->im_no );
}

void
cv_cnv_endian_OP_NMRID_TYPE( OP_NMRID_TYPE *_ecnv_target_ ) {
	{
		size_t _i60_0;
		for( _i60_0 = 0; _i60_0 < (12); ++_i60_0 ) {
			cv_cnv_endian_char( (char *)&((*_ecnv_target_)[_i60_0]) );
		}
	}
}

void
cv_cnv_endian_OP_HDR1_TYPE( OP_HDR1_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_n16( &_ecnv_target_->rev );
	cv_cnv_endian_n16( &_ecnv_target_->length );
	cv_cnv_endian_OP_NMRID_TYPE( &_ecnv_target_->req_nmrid );
	cv_cnv_endian_OP_NMRID_TYPE( &_ecnv_target_->resp_nmrid );
	cv_cnv_endian_n16( &_ecnv_target_->opcode );
	cv_cnv_endian_n16( &_ecnv_target_->packet_type );
	cv_cnv_endian_n16( &_ecnv_target_->seq_num );
	cv_cnv_endian_n32( &_ecnv_target_->status );
}

void
cv_cnv_endian_struct__OP_HDR_TYPE( struct _OP_HDR_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_s8( &_ecnv_target_->rev );
	cv_cnv_endian_s8( &_ecnv_target_->endian );
	cv_cnv_endian_n16( &_ecnv_target_->length );
	cv_cnv_endian_OP_NMRID_TYPE( &_ecnv_target_->req_nmrid );
	cv_cnv_endian_OP_NMRID_TYPE( &_ecnv_target_->resp_nmrid );
	cv_cnv_endian_n16( &_ecnv_target_->opcode );
	cv_cnv_endian_n16( &_ecnv_target_->packet_type );
	cv_cnv_endian_n16( &_ecnv_target_->seq_num );
	cv_cnv_endian_n16( &_ecnv_target_->pad );
	cv_cnv_endian_n32( &_ecnv_target_->status );
}

void
cv_cnv_endian_OP_HDR_TYPE( OP_HDR_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_struct__OP_HDR_TYPE( (struct _OP_HDR_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__OP_RECN_READY_TYPE( struct _OP_RECN_READY_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_DbKey( &_ecnv_target_->dbkey );
	cv_cnv_endian_s32( &_ecnv_target_->seq_number );
	cv_cnv_endian_GEtimespec( &_ecnv_target_->time_stamp );
	cv_cnv_endian_s32( &_ecnv_target_->run_no );
	cv_cnv_endian_s32( &_ecnv_target_->prep_flag );
	cv_cnv_endian_n32( &_ecnv_target_->patient_checksum );
	{
		size_t _i61_0;
		for( _i61_0 = 0; _i61_0 < (32); ++_i61_0 ) {
			cv_cnv_endian_char( &_ecnv_target_->clinicalCoilName[_i61_0] );
		}
	}
}

void
cv_cnv_endian_OP_RECN_READY_TYPE( OP_RECN_READY_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_struct__OP_RECN_READY_TYPE( (struct _OP_RECN_READY_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__OP_RECN_READY_PACK_TYPE( struct _OP_RECN_READY_PACK_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_OP_HDR_TYPE( &_ecnv_target_->hdr );
	cv_cnv_endian_OP_RECN_READY_TYPE( &_ecnv_target_->req );
}

void
cv_cnv_endian_OP_RECN_READY_PACK_TYPE( OP_RECN_READY_PACK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_struct__OP_RECN_READY_PACK_TYPE( (struct _OP_RECN_READY_PACK_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_OP_RECN_FOO_TYPE( OP_RECN_FOO_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_s32( &_ecnv_target_->somes32bitint );
	cv_cnv_endian_n16( &_ecnv_target_->somen16bitint );
	cv_cnv_endian_char( &_ecnv_target_->somechar );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->someulong );
	cv_cnv_endian_float( &_ecnv_target_->somefloat );
}

void
cv_cnv_endian_OP_RECN_FOO_PACK_TYPE( OP_RECN_FOO_PACK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_OP_HDR_TYPE( &_ecnv_target_->hdr );
	cv_cnv_endian_OP_RECN_FOO_TYPE( &_ecnv_target_->req );
}

void
cv_cnv_endian_struct__OP_RECN_START_TYPE( struct _OP_RECN_START_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_s32( &_ecnv_target_->seq_number );
	cv_cnv_endian_GEtimespec( &_ecnv_target_->time_stamp );
}

void
cv_cnv_endian_OP_RECN_START_TYPE( OP_RECN_START_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_struct__OP_RECN_START_TYPE( (struct _OP_RECN_START_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__OP_RECN_START_PACK_TYPE( struct _OP_RECN_START_PACK_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_OP_HDR_TYPE( &_ecnv_target_->hdr );
	cv_cnv_endian_OP_RECN_START_TYPE( &_ecnv_target_->req );
}

void
cv_cnv_endian_OP_RECN_START_PACK_TYPE( OP_RECN_START_PACK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_struct__OP_RECN_START_PACK_TYPE( (struct _OP_RECN_START_PACK_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_OP_RECN_SCAN_STOPPED_TYPE( OP_RECN_SCAN_STOPPED_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_s32( &_ecnv_target_->seq_number );
	cv_cnv_endian_s32( &_ecnv_target_->status );
	cv_cnv_endian_s32( &_ecnv_target_->aborted_pass_num );
}

void
cv_cnv_endian_OP_RECN_SCAN_STOPPED_PACK_TYPE( OP_RECN_SCAN_STOPPED_PACK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_OP_HDR_TYPE( &_ecnv_target_->hdr );
	cv_cnv_endian_OP_RECN_SCAN_STOPPED_TYPE( &_ecnv_target_->req );
}

void
cv_cnv_endian_OP_RECN_STOP_TYPE( OP_RECN_STOP_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_DbKey( &_ecnv_target_->dbkey );
	cv_cnv_endian_s32( &_ecnv_target_->seq_number );
	{
		size_t _i62_0;
		for( _i62_0 = 0; _i62_0 < (12); ++_i62_0 ) {
			cv_cnv_endian_char( &_ecnv_target_->scan_initiator[_i62_0] );
		}
	}
}

void
cv_cnv_endian_OP_RECN_STOP_PACK_TYPE( OP_RECN_STOP_PACK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_OP_HDR_TYPE( &_ecnv_target_->hdr );
	cv_cnv_endian_OP_RECN_STOP_TYPE( &_ecnv_target_->req );
}

void
cv_cnv_endian_OP_RECN_IM_ALLOC_TYPE( OP_RECN_IM_ALLOC_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_s32( &_ecnv_target_->seq_number );
}

void
cv_cnv_endian_OP_RECN_IM_ALLOC_PACK_TYPE( OP_RECN_IM_ALLOC_PACK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_OP_HDR_TYPE( &_ecnv_target_->hdr );
	cv_cnv_endian_OP_RECN_IM_ALLOC_TYPE( &_ecnv_target_->req );
}

void
cv_cnv_endian_OP_RECN_SCAN_STARTED_TYPE( OP_RECN_SCAN_STARTED_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_s32( &_ecnv_target_->seq_number );
}

void
cv_cnv_endian_OP_RECN_SCAN_STARTED_PACK_TYPE( OP_RECN_SCAN_STARTED_PACK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_OP_HDR_TYPE( &_ecnv_target_->hdr );
	cv_cnv_endian_OP_RECN_SCAN_STARTED_TYPE( &_ecnv_target_->req );
}

void
cv_cnv_endian_OP_VIEWTABLE_UPDATE_TYPE( OP_VIEWTABLE_UPDATE_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_s32( &_ecnv_target_->table_size );
	cv_cnv_endian_s32( &_ecnv_target_->block_size );
	cv_cnv_endian_s32( &_ecnv_target_->first_entry_index );
	{
		size_t _i63_0;
		for( _i63_0 = 0; _i63_0 < (256); ++_i63_0 ) {
			cv_cnv_endian_s32( &_ecnv_target_->table[_i63_0] );
		}
	}
}

void
cv_cnv_endian_OP_VIEWTABLE_UPDATE_PACK_TYPE( OP_VIEWTABLE_UPDATE_PACK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_OP_HDR_TYPE( &_ecnv_target_->hdr );
	cv_cnv_endian_OP_VIEWTABLE_UPDATE_TYPE( &_ecnv_target_->pkt );
}

void
cv_cnv_endian_MROR_ADDR_BLOCK( MROR_ADDR_BLOCK *_ecnv_target_ ) {
	cv_cnv_endian_n64( &_ecnv_target_->mrhdr );
	cv_cnv_endian_n64( &_ecnv_target_->pixelhdr );
	cv_cnv_endian_n64( &_ecnv_target_->pixeldata );
	cv_cnv_endian_n64( &_ecnv_target_->raw_offset );
	cv_cnv_endian_n64( &_ecnv_target_->raw_receivers );
	cv_cnv_endian_n64( &_ecnv_target_->pixeldata3 );
}

void
cv_cnv_endian_MROR_ADDR_BLOCK_PKT( MROR_ADDR_BLOCK_PKT *_ecnv_target_ ) {
	cv_cnv_endian_OP_HDR_TYPE( &_ecnv_target_->hdr );
	cv_cnv_endian_MROR_ADDR_BLOCK( &_ecnv_target_->mrab );
}

void
cv_cnv_endian_MROR_RETRIEVAL_DONE_TYPE( MROR_RETRIEVAL_DONE_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_n32( &_ecnv_target_->recon_ts );
}

void
cv_cnv_endian_MROR_ADDR_BLOCK_PACK_TYPE( MROR_ADDR_BLOCK_PACK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_OP_HDR_TYPE( &_ecnv_target_->hdr );
	cv_cnv_endian_MROR_RETRIEVAL_DONE_TYPE( &_ecnv_target_->retrieve_done );
}

void
cv_cnv_endian_SCAN_CALIB_INFO_TYPE( SCAN_CALIB_INFO_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_s32( &_ecnv_target_->exam_number );
	cv_cnv_endian_s32( &_ecnv_target_->calib_flag );
}

void
cv_cnv_endian_SCAN_CALIB_INFO_PACK_TYPE( SCAN_CALIB_INFO_PACK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_OP_HDR_TYPE( &_ecnv_target_->hdr );
	cv_cnv_endian_SCAN_CALIB_INFO_TYPE( &_ecnv_target_->info );
}

void
cv_cnv_endian_struct__OP_RECN_SIZE_CHECK_TYPE( struct _OP_RECN_SIZE_CHECK_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_n64( &_ecnv_target_->total_bam_size );
	cv_cnv_endian_n64( &_ecnv_target_->total_disk_size );
}

void
cv_cnv_endian_OP_RECN_SIZE_CHECK_TYPE( OP_RECN_SIZE_CHECK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_struct__OP_RECN_SIZE_CHECK_TYPE( (struct _OP_RECN_SIZE_CHECK_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__OP_RECN_SIZE_CHECK_PACK_TYPE( struct _OP_RECN_SIZE_CHECK_PACK_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_OP_HDR_TYPE( &_ecnv_target_->hdr );
	cv_cnv_endian_OP_RECN_SIZE_CHECK_TYPE( &_ecnv_target_->req );
}

void
cv_cnv_endian_OP_RECN_SIZE_CHECK_PACK_TYPE( OP_RECN_SIZE_CHECK_PACK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_struct__OP_RECN_SIZE_CHECK_PACK_TYPE( (struct _OP_RECN_SIZE_CHECK_PACK_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_EXAM_SCAN_DONE_TYPE( EXAM_SCAN_DONE_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_s32( &_ecnv_target_->exam_number );
}

void
cv_cnv_endian_EXAM_SCAN_DONE_PACK_TYPE( EXAM_SCAN_DONE_PACK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_OP_HDR_TYPE( &_ecnv_target_->hdr );
	cv_cnv_endian_EXAM_SCAN_DONE_TYPE( &_ecnv_target_->info );
}

void
cv_cnv_endian_struct__POSITION_DETECTION_DONE_TYPE( struct _POSITION_DETECTION_DONE_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_n32( &_ecnv_target_->object_detected );
	cv_cnv_endian_f32( &_ecnv_target_->object_si_position_mm );
	cv_cnv_endian_f32( &_ecnv_target_->right_most_voxel_mm );
	cv_cnv_endian_f32( &_ecnv_target_->anterior_most_voxel_mm );
	cv_cnv_endian_f32( &_ecnv_target_->superior_most_voxel_mm );
	cv_cnv_endian_n32( &_ecnv_target_->checksum );
}

void
cv_cnv_endian_POSITION_DETECTION_DONE_TYPE( POSITION_DETECTION_DONE_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_struct__POSITION_DETECTION_DONE_TYPE( (struct _POSITION_DETECTION_DONE_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__POSITION_DETECTION_DONE_PACK_TYPE( struct _POSITION_DETECTION_DONE_PACK_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_OP_HDR_TYPE( &_ecnv_target_->hdr );
	cv_cnv_endian_POSITION_DETECTION_DONE_TYPE( &_ecnv_target_->info );
}

void
cv_cnv_endian_POSITION_DETECTION_DONE_PACK_TYPE( POSITION_DETECTION_DONE_PACK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_struct__POSITION_DETECTION_DONE_PACK_TYPE( (struct _POSITION_DETECTION_DONE_PACK_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__OP_CTT_UPDATE_TYPE( struct _OP_CTT_UPDATE_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_s64( &_ecnv_target_->calUniqueNo );
	{
		size_t _i64_0;
		for( _i64_0 = 0; _i64_0 < (4); ++_i64_0 ) {
			cv_cnv_endian_ChannelTransTableEntryType( &_ecnv_target_->cttentry[_i64_0] );
		}
	}
	cv_cnv_endian_n32( &_ecnv_target_->errorCode );
}

void
cv_cnv_endian_OP_CTT_UPDATE_TYPE( OP_CTT_UPDATE_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_struct__OP_CTT_UPDATE_TYPE( (struct _OP_CTT_UPDATE_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__OP_CTT_UPDATE_PACK_TYPE( struct _OP_CTT_UPDATE_PACK_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_OP_HDR_TYPE( &_ecnv_target_->hdr );
	cv_cnv_endian_OP_CTT_UPDATE_TYPE( &_ecnv_target_->req );
}

void
cv_cnv_endian_OP_CTT_UPDATE_PACK_TYPE( OP_CTT_UPDATE_PACK_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_struct__OP_CTT_UPDATE_PACK_TYPE( (struct _OP_CTT_UPDATE_PACK_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_PSD_PSC_CONTROL( enum PSD_PSC_CONTROL *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_PSD_PSC_CONTROL_E( PSD_PSC_CONTROL_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_PSD_PSC_CONTROL( (enum PSD_PSC_CONTROL *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_GRADSHIM_SELECTION( enum GRADSHIM_SELECTION *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_GRADSHIM_SELECTION_E( GRADSHIM_SELECTION_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_GRADSHIM_SELECTION( (enum GRADSHIM_SELECTION *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_PRESSCFH_EXCITATION_TYPE( enum PRESSCFH_EXCITATION_TYPE *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_PRESSCFH_EXCITATION_TYPE_E( PRESSCFH_EXCITATION_TYPE_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_PRESSCFH_EXCITATION_TYPE( (enum PRESSCFH_EXCITATION_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_zy_index( struct zy_index *_ecnv_target_ )
{
	cv_cnv_endian_n16( &_ecnv_target_->view );
	cv_cnv_endian_n16( &_ecnv_target_->slice );
	cv_cnv_endian_n16( &_ecnv_target_->flags );
}

void
cv_cnv_endian_ZY_INDEX( ZY_INDEX *_ecnv_target_ ) {
	cv_cnv_endian_struct_zy_index( (struct zy_index *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_zy_dist1( struct zy_dist1 *_ecnv_target_ )
{
	cv_cnv_endian_float( &_ecnv_target_->distance );
	cv_cnv_endian_n16( &_ecnv_target_->view );
	cv_cnv_endian_n16( &_ecnv_target_->slice );
	cv_cnv_endian_n16( &_ecnv_target_->flags );
}

void
cv_cnv_endian_ZY_DIST1( ZY_DIST1 *_ecnv_target_ ) {
	cv_cnv_endian_struct_zy_dist1( (struct zy_dist1 *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__RDB_SLICE_INFO_ENTRY( struct _RDB_SLICE_INFO_ENTRY *_ecnv_target_ )
{
	cv_cnv_endian_short( &_ecnv_target_->pass_number );
	cv_cnv_endian_short( &_ecnv_target_->slice_in_pass );
	{
		size_t _i65_0;
		for( _i65_0 = 0; _i65_0 < (3); ++_i65_0 ) {
			cv_cnv_endian_float( &_ecnv_target_->gw_point1[_i65_0] );
		}
	}
	{
		size_t _i66_0;
		for( _i66_0 = 0; _i66_0 < (3); ++_i66_0 ) {
			cv_cnv_endian_float( &_ecnv_target_->gw_point2[_i66_0] );
		}
	}
	{
		size_t _i67_0;
		for( _i67_0 = 0; _i67_0 < (3); ++_i67_0 ) {
			cv_cnv_endian_float( &_ecnv_target_->gw_point3[_i67_0] );
		}
	}
	cv_cnv_endian_short( &_ecnv_target_->transpose );
	cv_cnv_endian_short( &_ecnv_target_->rotate );
	cv_cnv_endian_unsigned_int( &_ecnv_target_->coilConfigUID );
	cv_cnv_endian_float( &_ecnv_target_->fov_freq_scale );
	cv_cnv_endian_float( &_ecnv_target_->fov_phase_scale );
	cv_cnv_endian_float( &_ecnv_target_->slthick_scale );
	cv_cnv_endian_float( &_ecnv_target_->freq_loc_shift );
	cv_cnv_endian_float( &_ecnv_target_->phase_loc_shift );
	cv_cnv_endian_float( &_ecnv_target_->slice_loc_shift );
	cv_cnv_endian_short( &_ecnv_target_->sliceGroupId );
	cv_cnv_endian_short( &_ecnv_target_->sliceIndexInGroup );
}

void
cv_cnv_endian_RDB_SLICE_INFO_ENTRY( RDB_SLICE_INFO_ENTRY *_ecnv_target_ ) {
	cv_cnv_endian_struct__RDB_SLICE_INFO_ENTRY( (struct _RDB_SLICE_INFO_ENTRY *)_ecnv_target_ );
}

void
cv_cnv_endian_EXTERN_FILENAME( EXTERN_FILENAME *_ecnv_target_ ) {
	{
		size_t _i68_0;
		for( _i68_0 = 0; _i68_0 < (80); ++_i68_0 ) {
			cv_cnv_endian_char( (char *)&((*_ecnv_target_)[_i68_0]) );
		}
	}
}

void
cv_cnv_endian_EXTERN_FILENAME2( EXTERN_FILENAME2 *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian_float_t( float_t *_ecnv_target_ ) {
	cv_cnv_endian_long_double( (long double *)_ecnv_target_ );
}

void
cv_cnv_endian_double_t( double_t *_ecnv_target_ ) {
	cv_cnv_endian_long_double( (long double *)_ecnv_target_ );
}

void
cv_cnv_endian__LIB_VERSION_TYPE( _LIB_VERSION_TYPE *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_struct_exception( struct exception *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->type );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->name );
	cv_cnv_endian_double( &_ecnv_target_->arg1 );
	cv_cnv_endian_double( &_ecnv_target_->arg2 );
	cv_cnv_endian_double( &_ecnv_target_->retval );
}

void
cv_cnv_endian_union_wait( union wait *_ecnv_target_ )
{
}

void
cv_cnv_endian___WAIT_STATUS( __WAIT_STATUS *_ecnv_target_ ) {
}

void
cv_cnv_endian_div_t( div_t *_ecnv_target_ ) {
	cv_cnv_endian_int( &_ecnv_target_->quot );
	cv_cnv_endian_int( &_ecnv_target_->rem );
}

void
cv_cnv_endian_ldiv_t( ldiv_t *_ecnv_target_ ) {
	cv_cnv_endian_long( &_ecnv_target_->quot );
	cv_cnv_endian_long( &_ecnv_target_->rem );
}

void
cv_cnv_endian_lldiv_t( lldiv_t *_ecnv_target_ ) {
	cv_cnv_endian_long_long( &_ecnv_target_->quot );
	cv_cnv_endian_long_long( &_ecnv_target_->rem );
}

void
cv_cnv_endian_u_char( u_char *_ecnv_target_ ) {
	cv_cnv_endian___u_char( (__u_char *)_ecnv_target_ );
}

void
cv_cnv_endian_u_short( u_short *_ecnv_target_ ) {
	cv_cnv_endian___u_short( (__u_short *)_ecnv_target_ );
}

void
cv_cnv_endian_u_int( u_int *_ecnv_target_ ) {
	cv_cnv_endian___u_int( (__u_int *)_ecnv_target_ );
}

void
cv_cnv_endian_u_long( u_long *_ecnv_target_ ) {
	cv_cnv_endian___u_long( (__u_long *)_ecnv_target_ );
}

void
cv_cnv_endian_quad_t( quad_t *_ecnv_target_ ) {
	cv_cnv_endian___quad_t( (__quad_t *)_ecnv_target_ );
}

void
cv_cnv_endian_u_quad_t( u_quad_t *_ecnv_target_ ) {
	cv_cnv_endian___u_quad_t( (__u_quad_t *)_ecnv_target_ );
}

void
cv_cnv_endian_fsid_t( fsid_t *_ecnv_target_ ) {
	cv_cnv_endian___fsid_t( (__fsid_t *)_ecnv_target_ );
}

void
cv_cnv_endian_loff_t( loff_t *_ecnv_target_ ) {
	cv_cnv_endian___loff_t( (__loff_t *)_ecnv_target_ );
}

void
cv_cnv_endian_ino_t( ino_t *_ecnv_target_ ) {
	cv_cnv_endian___ino_t( (__ino_t *)_ecnv_target_ );
}

void
cv_cnv_endian_dev_t( dev_t *_ecnv_target_ ) {
	cv_cnv_endian___dev_t( (__dev_t *)_ecnv_target_ );
}

void
cv_cnv_endian_gid_t( gid_t *_ecnv_target_ ) {
	cv_cnv_endian___gid_t( (__gid_t *)_ecnv_target_ );
}

void
cv_cnv_endian_mode_t( mode_t *_ecnv_target_ ) {
	cv_cnv_endian___mode_t( (__mode_t *)_ecnv_target_ );
}

void
cv_cnv_endian_nlink_t( nlink_t *_ecnv_target_ ) {
	cv_cnv_endian___nlink_t( (__nlink_t *)_ecnv_target_ );
}

void
cv_cnv_endian_uid_t( uid_t *_ecnv_target_ ) {
	cv_cnv_endian___uid_t( (__uid_t *)_ecnv_target_ );
}

void
cv_cnv_endian_id_t( id_t *_ecnv_target_ ) {
	cv_cnv_endian___id_t( (__id_t *)_ecnv_target_ );
}

void
cv_cnv_endian_daddr_t( daddr_t *_ecnv_target_ ) {
	cv_cnv_endian___daddr_t( (__daddr_t *)_ecnv_target_ );
}

void
cv_cnv_endian_caddr_t( caddr_t *_ecnv_target_ ) {
	cv_cnv_endian___caddr_t( (__caddr_t *)_ecnv_target_ );
}

void
cv_cnv_endian_key_t( key_t *_ecnv_target_ ) {
	cv_cnv_endian___key_t( (__key_t *)_ecnv_target_ );
}

void
cv_cnv_endian_ulong( ulong *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian_ushort( ushort *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_short( (unsigned short *)_ecnv_target_ );
}

void
cv_cnv_endian_uint( uint *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian_u_int8_t( u_int8_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_char( (unsigned char *)_ecnv_target_ );
}

void
cv_cnv_endian_u_int16_t( u_int16_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_short( (unsigned short *)_ecnv_target_ );
}

void
cv_cnv_endian_u_int32_t( u_int32_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian_u_int64_t( u_int64_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long_long( (unsigned long long *)_ecnv_target_ );
}

void
cv_cnv_endian_register_t( register_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian___sig_atomic_t( __sig_atomic_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian___sigset_t( __sigset_t *_ecnv_target_ ) {
	{
		size_t _i69_0;
		for( _i69_0 = 0; _i69_0 < ((1024 / (8 * sizeof (unsigned long int)))); ++_i69_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->__val[_i69_0] );
		}
	}
}

void
cv_cnv_endian_sigset_t( sigset_t *_ecnv_target_ ) {
	cv_cnv_endian___sigset_t( (__sigset_t *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_timeval( struct timeval *_ecnv_target_ )
{
	cv_cnv_endian___time_t( &_ecnv_target_->tv_sec );
	cv_cnv_endian___suseconds_t( &_ecnv_target_->tv_usec );
}

void
cv_cnv_endian_suseconds_t( suseconds_t *_ecnv_target_ ) {
	cv_cnv_endian___suseconds_t( (__suseconds_t *)_ecnv_target_ );
}

void
cv_cnv_endian___fd_mask( __fd_mask *_ecnv_target_ ) {
	cv_cnv_endian_long( (long *)_ecnv_target_ );
}

void
cv_cnv_endian_fd_set( fd_set *_ecnv_target_ ) {
	{
		size_t _i70_0;
		for( _i70_0 = 0; _i70_0 < (1024 / (8 * (int) sizeof (__fd_mask))); ++_i70_0 ) {
			cv_cnv_endian___fd_mask( &_ecnv_target_->__fds_bits[_i70_0] );
		}
	}
}

void
cv_cnv_endian_fd_mask( fd_mask *_ecnv_target_ ) {
	cv_cnv_endian___fd_mask( (__fd_mask *)_ecnv_target_ );
}

void
cv_cnv_endian_blksize_t( blksize_t *_ecnv_target_ ) {
	cv_cnv_endian___blksize_t( (__blksize_t *)_ecnv_target_ );
}

void
cv_cnv_endian_blkcnt_t( blkcnt_t *_ecnv_target_ ) {
	cv_cnv_endian___blkcnt_t( (__blkcnt_t *)_ecnv_target_ );
}

void
cv_cnv_endian_fsblkcnt_t( fsblkcnt_t *_ecnv_target_ ) {
	cv_cnv_endian___fsblkcnt_t( (__fsblkcnt_t *)_ecnv_target_ );
}

void
cv_cnv_endian_fsfilcnt_t( fsfilcnt_t *_ecnv_target_ ) {
	cv_cnv_endian___fsfilcnt_t( (__fsfilcnt_t *)_ecnv_target_ );
}

void
cv_cnv_endian_pthread_t( pthread_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian_pthread_attr_t( pthread_attr_t *_ecnv_target_ ) {
}

void
cv_cnv_endian_struct___pthread_internal_slist( struct __pthread_internal_slist *_ecnv_target_ )
{
	cv_cnv_endian_unsigned_long( &_ecnv_target_->__next );
}

void
cv_cnv_endian___pthread_slist_t( __pthread_slist_t *_ecnv_target_ ) {
	cv_cnv_endian_struct___pthread_internal_slist( (struct __pthread_internal_slist *)_ecnv_target_ );
}

void
cv_cnv_endian_struct___pthread_mutex_s( struct __pthread_mutex_s *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->__lock );
	cv_cnv_endian_unsigned_int( &_ecnv_target_->__count );
	cv_cnv_endian_int( &_ecnv_target_->__owner );
	cv_cnv_endian_int( &_ecnv_target_->__kind );
	cv_cnv_endian_unsigned_int( &_ecnv_target_->__nusers );
	}

void
cv_cnv_endian_pthread_mutex_t( pthread_mutex_t *_ecnv_target_ ) {
}

void
cv_cnv_endian_pthread_mutexattr_t( pthread_mutexattr_t *_ecnv_target_ ) {
}

void
cv_cnv_endian_pthread_cond_t( pthread_cond_t *_ecnv_target_ ) {
}

void
cv_cnv_endian_pthread_condattr_t( pthread_condattr_t *_ecnv_target_ ) {
}

void
cv_cnv_endian_pthread_key_t( pthread_key_t *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_int( (unsigned int *)_ecnv_target_ );
}

void
cv_cnv_endian_pthread_once_t( pthread_once_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian_pthread_rwlock_t( pthread_rwlock_t *_ecnv_target_ ) {
}

void
cv_cnv_endian_pthread_rwlockattr_t( pthread_rwlockattr_t *_ecnv_target_ ) {
}

void
cv_cnv_endian_pthread_spinlock_t( pthread_spinlock_t *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *)_ecnv_target_ );
}

void
cv_cnv_endian_pthread_barrier_t( pthread_barrier_t *_ecnv_target_ ) {
}

void
cv_cnv_endian_pthread_barrierattr_t( pthread_barrierattr_t *_ecnv_target_ ) {
}

void
cv_cnv_endian_struct_random_data( struct random_data *_ecnv_target_ )
{
	cv_cnv_endian_unsigned_long( &_ecnv_target_->fptr );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->rptr );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->state );
	cv_cnv_endian_int( &_ecnv_target_->rand_type );
	cv_cnv_endian_int( &_ecnv_target_->rand_deg );
	cv_cnv_endian_int( &_ecnv_target_->rand_sep );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->end_ptr );
}

void
cv_cnv_endian_struct_drand48_data( struct drand48_data *_ecnv_target_ )
{
	{
		size_t _i71_0;
		for( _i71_0 = 0; _i71_0 < (3); ++_i71_0 ) {
			cv_cnv_endian_unsigned_short( &_ecnv_target_->__x[_i71_0] );
		}
	}
	{
		size_t _i72_0;
		for( _i72_0 = 0; _i72_0 < (3); ++_i72_0 ) {
			cv_cnv_endian_unsigned_short( &_ecnv_target_->__old_x[_i72_0] );
		}
	}
	cv_cnv_endian_unsigned_short( &_ecnv_target_->__c );
	cv_cnv_endian_unsigned_short( &_ecnv_target_->__init );
	cv_cnv_endian_unsigned_long_long( &_ecnv_target_->__a );
}

void
cv_cnv_endian_enum_aptype_e( enum aptype_e *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_aptype_t( aptype_t *_ecnv_target_ ) {
	cv_cnv_endian_enum_aptype_e( (enum aptype_e *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_dbLevel_e( enum dbLevel_e *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_dbLevel_t( dbLevel_t *_ecnv_target_ ) {
	cv_cnv_endian_enum_dbLevel_e( (enum dbLevel_e *)_ecnv_target_ );
}

void
cv_cnv_endian_COMPLEX( COMPLEX *_ecnv_target_ ) {
	cv_cnv_endian_float( &_ecnv_target_->real );
	cv_cnv_endian_float( &_ecnv_target_->imag );
}

void
cv_cnv_endian_PLAN_info( PLAN_info *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( &_ecnv_target_->fftwPlan );
	cv_cnv_endian_int( &_ecnv_target_->N );
	cv_cnv_endian_int( &_ecnv_target_->dir );
}

void
cv_cnv_endian_FFT_setup( FFT_setup *_ecnv_target_ ) {
	cv_cnv_endian_int( &_ecnv_target_->nelems );
	cv_cnv_endian_int( &_ecnv_target_->logb2_nelems );
	cv_cnv_endian_int( &_ecnv_target_->numPowOf2Plans );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->setupTmpv );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->FFTW_fplansBA );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->FFTW_fplansBU );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->FFTW_fplansFA );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->FFTW_fplansFU );
	cv_cnv_endian_PLAN_info( &_ecnv_target_->FFTW_fplanBA_fft1_cin );
	cv_cnv_endian_PLAN_info( &_ecnv_target_->FFTW_fplanBU_fft1_cin );
	cv_cnv_endian_PLAN_info( &_ecnv_target_->FFTW_fplanFA_fft1_cin );
	cv_cnv_endian_PLAN_info( &_ecnv_target_->FFTW_fplanFU_fft1_cin );
}

void
cv_cnv_endian_lcomplex( lcomplex *_ecnv_target_ ) {
	cv_cnv_endian_long( &_ecnv_target_->I );
	cv_cnv_endian_long( &_ecnv_target_->Q );
}

void
cv_cnv_endian_dcomplex( dcomplex *_ecnv_target_ ) {
	cv_cnv_endian_double( &_ecnv_target_->I );
	cv_cnv_endian_double( &_ecnv_target_->Q );
}

void
cv_cnv_endian_struct_mss_result_s( struct mss_result_s *_ecnv_target_ )
{
	cv_cnv_endian_INT( &_ecnv_target_->minseqgrad );
	cv_cnv_endian_INT( &_ecnv_target_->minseqcoil );
	cv_cnv_endian_INT( &_ecnv_target_->minseqcoilx );
	cv_cnv_endian_INT( &_ecnv_target_->minseqcoily );
	cv_cnv_endian_INT( &_ecnv_target_->minseqcoilz );
	cv_cnv_endian_INT( &_ecnv_target_->minseqcoilburst );
	cv_cnv_endian_INT( &_ecnv_target_->minseqcoilvrms );
	cv_cnv_endian_INT( &_ecnv_target_->minseqgrddrv );
	cv_cnv_endian_INT( &_ecnv_target_->minseqgrddrv_case );
	cv_cnv_endian_INT( &_ecnv_target_->minseqgpm );
	cv_cnv_endian_INT( &_ecnv_target_->minseqgpm_maxpow );
	cv_cnv_endian_INT( &_ecnv_target_->minseqpdu );
	cv_cnv_endian_INT( &_ecnv_target_->minseqps );
	cv_cnv_endian_INT( &_ecnv_target_->minseqpdubreaker );
	cv_cnv_endian_INT( &_ecnv_target_->minseqxfmr );
	cv_cnv_endian_INT( &_ecnv_target_->minseqcoilcool );
	cv_cnv_endian_INT( &_ecnv_target_->minseqsyscool );
	cv_cnv_endian_INT( &_ecnv_target_->minseqccucool );
	cv_cnv_endian_INT( &_ecnv_target_->minseqcable );
	cv_cnv_endian_INT( &_ecnv_target_->minseqcable_maxpow );
	cv_cnv_endian_INT( &_ecnv_target_->minseqcableburst );
	cv_cnv_endian_INT( &_ecnv_target_->minseqchoke );
	cv_cnv_endian_INT( &_ecnv_target_->minseqbusbar );
	cv_cnv_endian_FLOAT( &_ecnv_target_->vol_ratio_est_req );
	cv_cnv_endian_FLOAT( &_ecnv_target_->burstcooltime );
	cv_cnv_endian_FLOAT( &_ecnv_target_->xa2s );
	cv_cnv_endian_FLOAT( &_ecnv_target_->ya2s );
	cv_cnv_endian_FLOAT( &_ecnv_target_->za2s );
	cv_cnv_endian_FLOAT( &_ecnv_target_->ACxpower );
	cv_cnv_endian_FLOAT( &_ecnv_target_->ACypower );
	cv_cnv_endian_FLOAT( &_ecnv_target_->ACzpower );
	cv_cnv_endian_FLOAT( &_ecnv_target_->ACpowerSum_Watts );
	cv_cnv_endian_FLOAT( &_ecnv_target_->cableCurrentRMSmax_Amps );
	cv_cnv_endian_FLOAT( &_ecnv_target_->peakSPL );
	cv_cnv_endian_FLOAT( &_ecnv_target_->avgSPL );
	cv_cnv_endian_FLOAT( &_ecnv_target_->avgSPL_non_wt );
	{
		size_t _i73_0;
		for( _i73_0 = 0; _i73_0 < (3); ++_i73_0 ) {
			cv_cnv_endian_FLOAT( &_ecnv_target_->SGAlosslow[_i73_0] );
		}
	}
	{
		size_t _i74_0;
		for( _i74_0 = 0; _i74_0 < (3); ++_i74_0 ) {
			cv_cnv_endian_FLOAT( &_ecnv_target_->SGAlosshigh[_i74_0] );
		}
	}
	{
		size_t _i75_0;
		for( _i75_0 = 0; _i75_0 < (3); ++_i75_0 ) {
			cv_cnv_endian_FLOAT( &_ecnv_target_->XPSpowerhigh[_i75_0] );
		}
	}
	{
		size_t _i76_0;
		for( _i76_0 = 0; _i76_0 < (3); ++_i76_0 ) {
			cv_cnv_endian_FLOAT( &_ecnv_target_->XPSpowerlow[_i76_0] );
		}
	}
	cv_cnv_endian_INT( &_ecnv_target_->minseqcoil_3axis );
	{
		size_t _i77_0;
		for( _i77_0 = 0; _i77_0 < (3); ++_i77_0 ) {
			cv_cnv_endian_INT( &_ecnv_target_->minseqcoil_each[_i77_0] );
		}
	}
	{
		size_t _i78_0;
		for( _i78_0 = 0; _i78_0 < (3); ++_i78_0 ) {
			cv_cnv_endian_INT( &_ecnv_target_->minseqcable_each[_i78_0] );
		}
	}
	{
		size_t _i79_0;
		for( _i79_0 = 0; _i79_0 < (3); ++_i79_0 ) {
			cv_cnv_endian_INT( &_ecnv_target_->minseqcable_maxpow_each[_i79_0] );
		}
	}
	{
		size_t _i80_0;
		for( _i80_0 = 0; _i80_0 < (3); ++_i80_0 ) {
			cv_cnv_endian_INT( &_ecnv_target_->minseqgrddrv_case_each[_i80_0] );
		}
	}
	{
		size_t _i81_0;
		for( _i81_0 = 0; _i81_0 < (3); ++_i81_0 ) {
			cv_cnv_endian_INT( &_ecnv_target_->minseqgrddrv_each[_i81_0] );
		}
	}
	cv_cnv_endian_INT( &_ecnv_target_->minseqgpm_PDU );
	{
		size_t _i82_0;
		for( _i82_0 = 0; _i82_0 < (3); ++_i82_0 ) {
			cv_cnv_endian_INT( &_ecnv_target_->minseqgpm_each[_i82_0] );
		}
	}
	{
		size_t _i83_0;
		for( _i83_0 = 0; _i83_0 < (3); ++_i83_0 ) {
			cv_cnv_endian_INT( &_ecnv_target_->minseqgpm_LV_each[_i83_0] );
		}
	}
	{
		size_t _i84_0;
		for( _i84_0 = 0; _i84_0 < (3); ++_i84_0 ) {
			cv_cnv_endian_INT( &_ecnv_target_->minseqgpm_HV_each[_i84_0] );
		}
	}
	cv_cnv_endian_INT( &_ecnv_target_->minseqgpm_Itank );
	cv_cnv_endian_INT( &_ecnv_target_->minseqgpm_maxpow_3axis );
	{
		size_t _i85_0;
		for( _i85_0 = 0; _i85_0 < (3); ++_i85_0 ) {
			cv_cnv_endian_INT( &_ecnv_target_->minseqgpm_maxpow_each[_i85_0] );
		}
	}
	{
		size_t _i86_0;
		for( _i86_0 = 0; _i86_0 < (3); ++_i86_0 ) {
			cv_cnv_endian_INT( &_ecnv_target_->minseqps_each[_i86_0] );
		}
	}
	{
		size_t _i87_0;
		for( _i87_0 = 0; _i87_0 < (3); ++_i87_0 ) {
			cv_cnv_endian_INT( &_ecnv_target_->minseqchoke_each[_i87_0] );
		}
	}
	{
		size_t _i88_0;
		for( _i88_0 = 0; _i88_0 < (3); ++_i88_0 ) {
			cv_cnv_endian_INT( &_ecnv_target_->minseqbusbar_each[_i88_0] );
		}
	}
}

void
cv_cnv_endian_mss_result_t( mss_result_t *_ecnv_target_ ) {
	cv_cnv_endian_struct_mss_result_s( (struct mss_result_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_mss_hw_s( struct mss_hw_s *_ecnv_target_ )
{
	{
		size_t _i89_0;
		for( _i89_0 = 0; _i89_0 < (3); ++_i89_0 ) {
			cv_cnv_endian_double( &_ecnv_target_->amp2Gauss[_i89_0] );
		}
	}
	{
		size_t _i90_0;
		for( _i90_0 = 0; _i90_0 < (3); ++_i90_0 ) {
			cv_cnv_endian_double( &_ecnv_target_->maxCurrent[_i90_0] );
		}
	}
	cv_cnv_endian_double( &_ecnv_target_->gcontirms );
	{
		size_t _i91_0, _i91_1;
		for( _i91_0 = 0; _i91_0 < (3); ++_i91_0 )
		for( _i91_1 = 0; _i91_1 < (3); ++_i91_1 ) {
			cv_cnv_endian_double( &_ecnv_target_->irmsPerAxis[_i91_0][_i91_1] );
		}
	}
	cv_cnv_endian_int( &_ecnv_target_->gradamp );
	cv_cnv_endian_int( &_ecnv_target_->gcoiltype );
	cv_cnv_endian_int( &_ecnv_target_->gradmode );
	cv_cnv_endian_int( &_ecnv_target_->srmode );
	cv_cnv_endian_int( &_ecnv_target_->updateTime );
	cv_cnv_endian_float( &_ecnv_target_->coilDC_gain );
	cv_cnv_endian_float( &_ecnv_target_->coilDC_Rx );
	cv_cnv_endian_float( &_ecnv_target_->coilDC_Ry );
	cv_cnv_endian_float( &_ecnv_target_->coilDC_Rz );
	cv_cnv_endian_float( &_ecnv_target_->coilDC_Lx );
	cv_cnv_endian_float( &_ecnv_target_->coilDC_Ly );
	cv_cnv_endian_float( &_ecnv_target_->coilDC_Lz );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_gain );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_xgain );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_ygain );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_zgain );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_power );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_power_1axis );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_powerburst );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_temp_base_burst );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_temp_limit_burst );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_timeconstant_burst );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_RxA );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_RyA );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_RzA );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_RxB );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_RyB );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_RzB );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_RxC );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_RyC );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_RzC );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpR1x );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpR1y );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpR1z );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpR2x );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpR2y );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpR2z );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpL1x );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpL1y );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpL1z );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpL2x );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpL2y );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpL2z );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpL3x );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpL3y );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpL3z );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpR3x );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpR3y );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpR3z );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpL4x );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpL4y );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpL4z );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpR4x );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpR4y );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpR4z );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpR5x );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpR5y );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpR5z );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpCx );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpCy );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpCz );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpRcable );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpRoutputFilter );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_lumpLoutputFilter );
	cv_cnv_endian_float( &_ecnv_target_->coilAC_timeres );
	cv_cnv_endian_int( &_ecnv_target_->coilAC_fftpoints );
	{
		size_t _i92_0;
		for( _i92_0 = 0; _i92_0 < (7); ++_i92_0 ) {
			cv_cnv_endian_float( &_ecnv_target_->coilQAC_A[_i92_0] );
		}
	}
	{
		size_t _i93_0;
		for( _i93_0 = 0; _i93_0 < (3); ++_i93_0 ) {
			cv_cnv_endian_float( &_ecnv_target_->coilQAC_B[_i93_0] );
		}
	}
	cv_cnv_endian_float( &_ecnv_target_->coilQAC_maxtime );
	cv_cnv_endian_float( &_ecnv_target_->coilQAC_const );
	cv_cnv_endian_float( &_ecnv_target_->coilQAC_heat_maxtime );
	cv_cnv_endian_float( &_ecnv_target_->coilQAC_heat_slope );
	cv_cnv_endian_float( &_ecnv_target_->coilQAC_heat_const );
	cv_cnv_endian_float( &_ecnv_target_->coil_irmslimit_total );
	cv_cnv_endian_float( &_ecnv_target_->xgd_timeres );
	cv_cnv_endian_float( &_ecnv_target_->xgd_cableirmslimit );
	cv_cnv_endian_float( &_ecnv_target_->xgd_cableirmslimit_burst );
	cv_cnv_endian_float( &_ecnv_target_->xgd_cabletimeconstant_burst );
	cv_cnv_endian_float( &_ecnv_target_->xgd_chokepowerlimit );
	cv_cnv_endian_float( &_ecnv_target_->xgd_busbartemplimit );
	cv_cnv_endian_float( &_ecnv_target_->xps_avglvpwrlimit );
	cv_cnv_endian_float( &_ecnv_target_->xps_avghvpwrlimit );
	cv_cnv_endian_float( &_ecnv_target_->xps_avgpdulimit );
	cv_cnv_endian_float( &_ecnv_target_->xgd_IGBTtemplimit );
	cv_cnv_endian_float( &_ecnv_target_->xfd_power_limit );
	cv_cnv_endian_float( &_ecnv_target_->xfd_temp_limit );
	cv_cnv_endian_int( &_ecnv_target_->ecc_modeling );
	cv_cnv_endian_float( &_ecnv_target_->ecc_xtau1 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_xtau2 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_xtau3 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_ytau1 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_ytau2 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_ytau3 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_ztau1 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_ztau2 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_ztau3 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_xalpha1 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_xalpha2 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_xalpha3 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_yalpha1 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_yalpha2 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_yalpha3 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_zalpha1 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_zalpha2 );
	cv_cnv_endian_float( &_ecnv_target_->ecc_zalpha3 );
	cv_cnv_endian_float( &_ecnv_target_->ps_avgpwrLimit );
	cv_cnv_endian_float( &_ecnv_target_->ps_avgpwrLimit_total );
	cv_cnv_endian_float( &_ecnv_target_->ps_pkpwrLimit );
	cv_cnv_endian_float( &_ecnv_target_->ps_pkpwrLimit_total );
	cv_cnv_endian_float( &_ecnv_target_->pdu_avgpwrLimit );
	cv_cnv_endian_float( &_ecnv_target_->pdu_pkpwrLimit );
	cv_cnv_endian_float( &_ecnv_target_->pdu_breakercurrentLimit );
	cv_cnv_endian_float( &_ecnv_target_->cooling_coilLimit );
	cv_cnv_endian_float( &_ecnv_target_->cooling_ccuLimit );
	cv_cnv_endian_float( &_ecnv_target_->cooling_sysLimit );
	cv_cnv_endian_float( &_ecnv_target_->coilACpower_axisPer );
	cv_cnv_endian_int( &_ecnv_target_->cooling_model );
	cv_cnv_endian_float( &_ecnv_target_->xfmr_rmsLimit );
	cv_cnv_endian_float( &_ecnv_target_->coil_vrmsLimit );
	cv_cnv_endian_float( &_ecnv_target_->resist_wattLimit );
	cv_cnv_endian_int( &_ecnv_target_->seq_repeat_rate );
}

void
cv_cnv_endian_mss_hw_t( mss_hw_t *_ecnv_target_ ) {
	cv_cnv_endian_struct_mss_hw_s( (struct mss_hw_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_mss_wave_s( struct mss_wave_s *_ecnv_target_ )
{
	cv_cnv_endian_unsigned_long( &_ecnv_target_->time );
	{
		size_t _i94_0;
		for( _i94_0 = 0; _i94_0 < (3); ++_i94_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->ampl[_i94_0] );
		}
	}
	{
		size_t _i95_0;
		for( _i95_0 = 0; _i95_0 < (3); ++_i95_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->pul_type[_i95_0] );
		}
	}
	cv_cnv_endian_INT( &_ecnv_target_->num_points );
	cv_cnv_endian_INT( &_ecnv_target_->num_iters );
	cv_cnv_endian_INT( &_ecnv_target_->encode_mode );
	cv_cnv_endian_INT( &_ecnv_target_->burstreps );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->resampledTime );
	{
		size_t _i96_0;
		for( _i96_0 = 0; _i96_0 < (3); ++_i96_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->resampledCurrent[_i96_0] );
		}
	}
	{
		size_t _i97_0;
		for( _i97_0 = 0; _i97_0 < (3); ++_i97_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->resampledCurrentFFT[_i97_0] );
		}
	}
	{
		size_t _i98_0;
		for( _i98_0 = 0; _i98_0 < (3); ++_i98_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->resampledVoltage[_i98_0] );
		}
	}
	{
		size_t _i99_0;
		for( _i99_0 = 0; _i99_0 < (3); ++_i99_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->resampledPower[_i99_0] );
		}
	}
	cv_cnv_endian_INT( &_ecnv_target_->resampledTotalPoints );
	{
		size_t _i100_0;
		for( _i100_0 = 0; _i100_0 < (3); ++_i100_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->amplifierLoss[_i100_0] );
		}
	}
	cv_cnv_endian_FLOAT( &_ecnv_target_->resampledTimeStep );
	{
		size_t _i101_0;
		for( _i101_0 = 0; _i101_0 < (3); ++_i101_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->netLoad[_i101_0] );
		}
	}
	{
		size_t _i102_0;
		for( _i102_0 = 0; _i102_0 < (3); ++_i102_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->Pcoil_ladder[_i102_0] );
		}
	}
	{
		size_t _i103_0;
		for( _i103_0 = 0; _i103_0 < (3); ++_i103_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->Pcoil_ladderWorst[_i103_0] );
		}
	}
}

void
cv_cnv_endian_mss_wave_t( mss_wave_t *_ecnv_target_ ) {
	cv_cnv_endian_struct_mss_wave_s( (struct mss_wave_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_mss_waveforms_s( struct mss_waveforms_s *_ecnv_target_ )
{
	cv_cnv_endian_unsigned_long( &_ecnv_target_->average );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->maximum );
}

void
cv_cnv_endian_mss_waveforms_t( mss_waveforms_t *_ecnv_target_ ) {
	cv_cnv_endian_struct_mss_waveforms_s( (struct mss_waveforms_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_mss_geo_s( struct mss_geo_s *_ecnv_target_ )
{
	cv_cnv_endian_unsigned_long( &_ecnv_target_->lscninfo );
	cv_cnv_endian_INT( &_ecnv_target_->n_slices );
}

void
cv_cnv_endian_mss_geo_t( mss_geo_t *_ecnv_target_ ) {
	cv_cnv_endian_struct_mss_geo_s( (struct mss_geo_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_mss_flags_s( struct mss_flags_s *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->hiFreqMode );
	cv_cnv_endian_int( &_ecnv_target_->coilCompositeRMSMethod );
	cv_cnv_endian_int( &_ecnv_target_->psCompositeIntegralMethod );
	cv_cnv_endian_int( &_ecnv_target_->sgaGradDriverMethod );
	cv_cnv_endian_int( &_ecnv_target_->gradHeatFile );
	cv_cnv_endian_int( &_ecnv_target_->gradCoilMethod );
	cv_cnv_endian_int( &_ecnv_target_->burstMode );
	cv_cnv_endian_int( &_ecnv_target_->stopwatchFlag );
	cv_cnv_endian_int( &_ecnv_target_->cveval_counter );
	cv_cnv_endian_int( &_ecnv_target_->value_system_flag );
	cv_cnv_endian_int( &_ecnv_target_->e_flag );
	cv_cnv_endian_dbLevel_t( &_ecnv_target_->debug );
	cv_cnv_endian_int( &_ecnv_target_->xgd_optimization );
	cv_cnv_endian_int( &_ecnv_target_->eccupdatetime );
	cv_cnv_endian_int( &_ecnv_target_->checkMxPath );
	cv_cnv_endian_int( &_ecnv_target_->runCapBankModel );
	cv_cnv_endian_int( &_ecnv_target_->acoustic_flag );
	cv_cnv_endian_int( &_ecnv_target_->enable_grad_model_logging );
}

void
cv_cnv_endian_mss_flags_t( mss_flags_t *_ecnv_target_ ) {
	cv_cnv_endian_struct_mss_flags_s( (struct mss_flags_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_s_list( struct s_list *_ecnv_target_ )
{
	cv_cnv_endian_INT( &_ecnv_target_->time );
	cv_cnv_endian_FLOAT( &_ecnv_target_->ampl );
	cv_cnv_endian_INT( &_ecnv_target_->ptype );
}

void
cv_cnv_endian_t_list( t_list *_ecnv_target_ ) {
	cv_cnv_endian_struct_s_list( (struct s_list *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_logging_apptype( enum logging_apptype *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_logging_apptype_e( logging_apptype_e *_ecnv_target_ ) {
	cv_cnv_endian_enum_logging_apptype( (enum logging_apptype *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_log_level( enum log_level *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_log_level_e( log_level_e *_ecnv_target_ ) {
	cv_cnv_endian_enum_log_level( (enum log_level *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_trace_level( enum trace_level *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_trace_level_e( trace_level_e *_ecnv_target_ ) {
	cv_cnv_endian_enum_trace_level( (enum trace_level *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_trace_file_name_style( enum trace_file_name_style *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_trace_file_name_style_e( trace_file_name_style_e *_ecnv_target_ ) {
	cv_cnv_endian_enum_trace_file_name_style( (enum trace_file_name_style *)_ecnv_target_ );
}

void
cv_cnv_endian_log_trace_return_e( log_trace_return_e *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_trace_module( trace_module *_ecnv_target_ ) {
	cv_cnv_endian_unsigned_long( (unsigned long *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_maxslquanttps_option( struct maxslquanttps_option *_ecnv_target_ )
{
	cv_cnv_endian_FLOAT( &_ecnv_target_->arcRxToAcqSlicesSlope );
	cv_cnv_endian_FLOAT( &_ecnv_target_->arcRxToAcqSlicesIntercept );
	cv_cnv_endian_INT( &_ecnv_target_->discoTotalAcqPoints );
}

void
cv_cnv_endian_MAXSLQUANTTPS_OPTION( MAXSLQUANTTPS_OPTION *_ecnv_target_ ) {
	cv_cnv_endian_struct_maxslquanttps_option( (struct maxslquanttps_option *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_slicesort_acq_type( enum slicesort_acq_type *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_slicesort_acq_type_e( slicesort_acq_type_e *_ecnv_target_ ) {
	cv_cnv_endian_enum_slicesort_acq_type( (enum slicesort_acq_type *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_jstdPositionErr_e( enum jstdPositionErr_e *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_jstdPositionErr_e( jstdPositionErr_e *_ecnv_target_ ) {
	cv_cnv_endian_enum_jstdPositionErr_e( (enum jstdPositionErr_e *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_jstdConditions_s( struct jstdConditions_s *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->activate );
	cv_cnv_endian_double( &_ecnv_target_->mass );
	cv_cnv_endian_n32( &_ecnv_target_->tx_coil_type );
}

void
cv_cnv_endian_jstdConditions_t( jstdConditions_t *_ecnv_target_ ) {
	cv_cnv_endian_struct_jstdConditions_s( (struct jstdConditions_s *)_ecnv_target_ );
}

void
cv_cnv_endian_jstdReferencePosition_t( jstdReferencePosition_t *_ecnv_target_ ) {
	cv_cnv_endian_POSITION_DETECTION_DONE_TYPE( (POSITION_DETECTION_DONE_TYPE *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_jstdPositionResult_s( struct jstdPositionResult_s *_ecnv_target_ )
{
	cv_cnv_endian_double( &_ecnv_target_->wholeBodyJstd );
	cv_cnv_endian_double( &_ecnv_target_->headJstdFraction );
	cv_cnv_endian_double( &_ecnv_target_->headJstd );
	cv_cnv_endian_double( &_ecnv_target_->headMass );
	cv_cnv_endian_double( &_ecnv_target_->partialBodyMassFraction );
	cv_cnv_endian_double( &_ecnv_target_->partialBodyJstdFraction );
	cv_cnv_endian_double( &_ecnv_target_->offset );
	cv_cnv_endian_jstdPositionErr_e( &_ecnv_target_->errcode );
}

void
cv_cnv_endian_jstdPositionResult_t( jstdPositionResult_t *_ecnv_target_ ) {
	cv_cnv_endian_struct_jstdPositionResult_s( (struct jstdPositionResult_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_jstdResults_s( struct jstdResults_s *_ecnv_target_ )
{
	cv_cnv_endian_double( &_ecnv_target_->coilJstd );
	cv_cnv_endian_double( &_ecnv_target_->coilMeanJstd );
	cv_cnv_endian_jstdPositionResult_t( &_ecnv_target_->rxPosition );
}

void
cv_cnv_endian_jstdResults_t( jstdResults_t *_ecnv_target_ ) {
	cv_cnv_endian_struct_jstdResults_s( (struct jstdResults_s *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_scalerfpulses_b1_derate_type( enum scalerfpulses_b1_derate_type *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_scalerfpulses_b1_derate_type_e( scalerfpulses_b1_derate_type_e *_ecnv_target_ ) {
	cv_cnv_endian_enum_scalerfpulses_b1_derate_type( (enum scalerfpulses_b1_derate_type *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_DABOUTHUBINDEX( enum DABOUTHUBINDEX *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_DABOUTHUBINDEX_E( DABOUTHUBINDEX_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_DABOUTHUBINDEX( (enum DABOUTHUBINDEX *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_DATA_FRAME_DESTINATION( enum DATA_FRAME_DESTINATION *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_DATA_FRAME_DESTINATION_E( DATA_FRAME_DESTINATION_E *_ecnv_target_ ) {
	cv_cnv_endian_enum_DATA_FRAME_DESTINATION( (enum DATA_FRAME_DESTINATION *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_IMGOPT( enum IMGOPT *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_enum_psd_iopt_nums( enum psd_iopt_nums *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_psd_iopt_e( psd_iopt_e *_ecnv_target_ ) {
	cv_cnv_endian_enum_psd_iopt_nums( (enum psd_iopt_nums *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_psdiopt_s( struct psdiopt_s *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->iopt_num );
	{
		size_t _i104_0;
		for( _i104_0 = 0; _i104_0 < (8192); ++_i104_0 ) {
			cv_cnv_endian_char( &_ecnv_target_->iopt_name[_i104_0] );
		}
	}
	cv_cnv_endian_unsigned_long( &_ecnv_target_->slot );
	cv_cnv_endian_int( &_ecnv_target_->key );
	cv_cnv_endian_int( &_ecnv_target_->max_on_state );
	cv_cnv_endian_int( &_ecnv_target_->max_off_state );
	cv_cnv_endian_int( &_ecnv_target_->def_on_state );
	cv_cnv_endian_int( &_ecnv_target_->def_off_state );
}

void
cv_cnv_endian_psdiopt_t( psdiopt_t *_ecnv_target_ ) {
	cv_cnv_endian_struct_psdiopt_s( (struct psdiopt_s *)_ecnv_target_ );
}

void
cv_cnv_endian_KS_DESCRIPTION( KS_DESCRIPTION *_ecnv_target_ ) {
	{
		size_t _i105_0;
		for( _i105_0 = 0; _i105_0 < (128); ++_i105_0 ) {
			cv_cnv_endian_char( (char *)&((*_ecnv_target_)[_i105_0]) );
		}
	}
}

void
cv_cnv_endian_KS_WAVEFORM( KS_WAVEFORM *_ecnv_target_ ) {
	{
		size_t _i106_0;
		for( _i106_0 = 0; _i106_0 < (10000); ++_i106_0 ) {
			cv_cnv_endian_float( (float *)&((*_ecnv_target_)[_i106_0]) );
		}
	}
}

void
cv_cnv_endian_KS_IWAVE( KS_IWAVE *_ecnv_target_ ) {
	{
		size_t _i107_0;
		for( _i107_0 = 0; _i107_0 < (10000); ++_i107_0 ) {
			cv_cnv_endian_short( (short *)&((*_ecnv_target_)[_i107_0]) );
		}
	}
}

void
cv_cnv_endian_KS_MAT3x3( KS_MAT3x3 *_ecnv_target_ ) {
	{
		size_t _i108_0;
		for( _i108_0 = 0; _i108_0 < (9); ++_i108_0 ) {
			cv_cnv_endian_double( (double *)&((*_ecnv_target_)[_i108_0]) );
		}
	}
}

void
cv_cnv_endian_KS_MAT4x4( KS_MAT4x4 *_ecnv_target_ ) {
	{
		size_t _i109_0;
		for( _i109_0 = 0; _i109_0 < (16); ++_i109_0 ) {
			cv_cnv_endian_double( (double *)&((*_ecnv_target_)[_i109_0]) );
		}
	}
}

void
cv_cnv_endian_KS_PLOT_FILEFORMATS( KS_PLOT_FILEFORMATS *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_KS_PLOT_EXCITATION_MODE( KS_PLOT_EXCITATION_MODE *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_KS_PLOT_PASS_MODE( KS_PLOT_PASS_MODE *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_struct__seqloc_s( struct _seqloc_s *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->board );
	cv_cnv_endian_int( &_ecnv_target_->pos );
	cv_cnv_endian_float( &_ecnv_target_->ampscale );
}

void
cv_cnv_endian_KS_SEQLOC( KS_SEQLOC *_ecnv_target_ ) {
	cv_cnv_endian_struct__seqloc_s( (struct _seqloc_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__wfinstance_s( struct _wfinstance_s *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->boardinstance );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->wf );
	cv_cnv_endian_KS_SEQLOC( &_ecnv_target_->loc );
}

void
cv_cnv_endian_KS_WFINSTANCE( KS_WFINSTANCE *_ecnv_target_ ) {
	cv_cnv_endian_struct__wfinstance_s( (struct _wfinstance_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__base_s( struct _base_s *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->ninst );
	cv_cnv_endian_int( &_ecnv_target_->ngenerated );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->next );
	cv_cnv_endian_int( &_ecnv_target_->size );
}

void
cv_cnv_endian_KS_BASE( KS_BASE *_ecnv_target_ ) {
	cv_cnv_endian_struct__base_s( (struct _base_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__wait_s( struct _wait_s *_ecnv_target_ )
{
	cv_cnv_endian_KS_BASE( &_ecnv_target_->base );
	cv_cnv_endian_KS_DESCRIPTION( &_ecnv_target_->description );
	cv_cnv_endian_int( &_ecnv_target_->duration );
	{
		size_t _i110_0;
		for( _i110_0 = 0; _i110_0 < (500); ++_i110_0 ) {
			cv_cnv_endian_KS_SEQLOC( &_ecnv_target_->locs[_i110_0] );
		}
	}
	cv_cnv_endian_unsigned_long( &_ecnv_target_->wfpulse );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->wfi );
}

void
cv_cnv_endian_KS_WAIT( KS_WAIT *_ecnv_target_ ) {
	cv_cnv_endian_struct__wait_s( (struct _wait_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__isirot_s( struct _isirot_s *_ecnv_target_ )
{
	cv_cnv_endian_KS_WAIT( &_ecnv_target_->waitfun );
	cv_cnv_endian_KS_WAIT( &_ecnv_target_->waitrot );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->scan_info );
	cv_cnv_endian_int( &_ecnv_target_->isinumber );
	cv_cnv_endian_int( &_ecnv_target_->duration );
	cv_cnv_endian_int( &_ecnv_target_->counter );
	cv_cnv_endian_int( &_ecnv_target_->numinstances );
}

void
cv_cnv_endian_KS_ISIROT( KS_ISIROT *_ecnv_target_ ) {
	cv_cnv_endian_struct__isirot_s( (struct _isirot_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__trap_s( struct _trap_s *_ecnv_target_ )
{
	cv_cnv_endian_KS_BASE( &_ecnv_target_->base );
	cv_cnv_endian_KS_DESCRIPTION( &_ecnv_target_->description );
	cv_cnv_endian_float( &_ecnv_target_->amp );
	cv_cnv_endian_float( &_ecnv_target_->area );
	cv_cnv_endian_int( &_ecnv_target_->ramptime );
	cv_cnv_endian_int( &_ecnv_target_->plateautime );
	cv_cnv_endian_int( &_ecnv_target_->duration );
	{
		size_t _i111_0;
		for( _i111_0 = 0; _i111_0 < (3); ++_i111_0 ) {
			cv_cnv_endian_int( &_ecnv_target_->gradnum[_i111_0] );
		}
	}
	{
		size_t _i112_0;
		for( _i112_0 = 0; _i112_0 < (500); ++_i112_0 ) {
			cv_cnv_endian_KS_SEQLOC( &_ecnv_target_->locs[_i112_0] );
		}
	}
	cv_cnv_endian_unsigned_long( &_ecnv_target_->wfpulse );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->wfi );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->rtscale );
}

void
cv_cnv_endian_KS_TRAP( KS_TRAP *_ecnv_target_ ) {
	cv_cnv_endian_struct__trap_s( (struct _trap_s *)_ecnv_target_ );
}

void
cv_cnv_endian_KS_WAVE( KS_WAVE *_ecnv_target_ ) {
	cv_cnv_endian_KS_BASE( &_ecnv_target_->base );
	cv_cnv_endian_KS_DESCRIPTION( &_ecnv_target_->description );
	cv_cnv_endian_int( &_ecnv_target_->res );
	cv_cnv_endian_int( &_ecnv_target_->duration );
	cv_cnv_endian_KS_WAVEFORM( &_ecnv_target_->waveform );
	{
		size_t _i113_0;
		for( _i113_0 = 0; _i113_0 < (3); ++_i113_0 ) {
			cv_cnv_endian_int( &_ecnv_target_->gradnum[_i113_0] );
		}
	}
	cv_cnv_endian_int( &_ecnv_target_->gradwave_units );
	{
		size_t _i114_0;
		for( _i114_0 = 0; _i114_0 < (500); ++_i114_0 ) {
			cv_cnv_endian_KS_SEQLOC( &_ecnv_target_->locs[_i114_0] );
		}
	}
	cv_cnv_endian_unsigned_long( &_ecnv_target_->wfpulse );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->wfi );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->rtscale );
}

void
cv_cnv_endian_struct__acq_s( struct _acq_s *_ecnv_target_ )
{
	cv_cnv_endian_KS_BASE( &_ecnv_target_->base );
	cv_cnv_endian_KS_DESCRIPTION( &_ecnv_target_->description );
	cv_cnv_endian_int( &_ecnv_target_->duration );
	cv_cnv_endian_float( &_ecnv_target_->rbw );
	cv_cnv_endian_FILTER_INFO( &_ecnv_target_->filt );
	{
		size_t _i115_0;
		for( _i115_0 = 0; _i115_0 < (500); ++_i115_0 ) {
			cv_cnv_endian_int( &_ecnv_target_->pos[_i115_0] );
		}
	}
	cv_cnv_endian_unsigned_long( &_ecnv_target_->echo );
}

void
cv_cnv_endian_KS_READ( KS_READ *_ecnv_target_ ) {
	cv_cnv_endian_struct__acq_s( (struct _acq_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__rf_s( struct _rf_s *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->role );
	cv_cnv_endian_float( &_ecnv_target_->flip );
	cv_cnv_endian_float( &_ecnv_target_->bw );
	cv_cnv_endian_float( &_ecnv_target_->cf_offset );
	cv_cnv_endian_float( &_ecnv_target_->amp );
	cv_cnv_endian_int( &_ecnv_target_->start2iso );
	cv_cnv_endian_int( &_ecnv_target_->iso2end );
	cv_cnv_endian_int( &_ecnv_target_->iso2end_subpulse );
	cv_cnv_endian_KS_DESCRIPTION( &_ecnv_target_->designinfo );
	cv_cnv_endian_RF_PULSE( &_ecnv_target_->rfpulse );
	cv_cnv_endian_KS_WAVE( &_ecnv_target_->rfwave );
	cv_cnv_endian_KS_WAVE( &_ecnv_target_->omegawave );
	cv_cnv_endian_KS_WAVE( &_ecnv_target_->thetawave );
}

void
cv_cnv_endian_KS_RF( KS_RF *_ecnv_target_ ) {
	cv_cnv_endian_struct__rf_s( (struct _rf_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__gradrfctrl_s( struct _gradrfctrl_s *_ecnv_target_ )
{
	{
		size_t _i116_0;
		for( _i116_0 = 0; _i116_0 < (20); ++_i116_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->rfptr[_i116_0] );
		}
	}
	cv_cnv_endian_int( &_ecnv_target_->numrf );
	{
		size_t _i117_0;
		for( _i117_0 = 0; _i117_0 < (200); ++_i117_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->trapptr[_i117_0] );
		}
	}
	cv_cnv_endian_int( &_ecnv_target_->numtrap );
	{
		size_t _i118_0;
		for( _i118_0 = 0; _i118_0 < (200); ++_i118_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->waveptr[_i118_0] );
		}
	}
	cv_cnv_endian_int( &_ecnv_target_->numwave );
	{
		size_t _i119_0;
		for( _i119_0 = 0; _i119_0 < (500); ++_i119_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->readptr[_i119_0] );
		}
	}
	cv_cnv_endian_int( &_ecnv_target_->numacq );
	cv_cnv_endian_int( &_ecnv_target_->is_cleared_on_tgt );
}

void
cv_cnv_endian_KS_GRADRFCTRL( KS_GRADRFCTRL *_ecnv_target_ ) {
	cv_cnv_endian_struct__gradrfctrl_s( (struct _gradrfctrl_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__seq_handle_s( struct _seq_handle_s *_ecnv_target_ )
{
	cv_cnv_endian_unsigned_long( &_ecnv_target_->offset );
	cv_cnv_endian_int( &_ecnv_target_->index );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->pulse );
}

void
cv_cnv_endian_KS_SEQ_HANDLE( KS_SEQ_HANDLE *_ecnv_target_ ) {
	cv_cnv_endian_struct__seq_handle_s( (struct _seq_handle_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__seq_control_s( struct _seq_control_s *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->min_duration );
	cv_cnv_endian_int( &_ecnv_target_->nseqinstances );
	cv_cnv_endian_int( &_ecnv_target_->ssi_time );
	cv_cnv_endian_int( &_ecnv_target_->duration );
	cv_cnv_endian_int( &_ecnv_target_->momentstart );
	cv_cnv_endian_int( &_ecnv_target_->rfscalingdone );
	cv_cnv_endian_KS_DESCRIPTION( &_ecnv_target_->description );
	cv_cnv_endian_KS_SEQ_HANDLE( &_ecnv_target_->handle );
	cv_cnv_endian_KS_GRADRFCTRL( &_ecnv_target_->gradrf );
}

void
cv_cnv_endian_KS_SEQ_CONTROL( KS_SEQ_CONTROL *_ecnv_target_ ) {
	cv_cnv_endian_struct__seq_control_s( (struct _seq_control_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__seq_collection_s( struct _seq_collection_s *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->numseq );
	cv_cnv_endian_int( &_ecnv_target_->mode );
	cv_cnv_endian_int( &_ecnv_target_->evaltrdone );
	{
		size_t _i120_0;
		for( _i120_0 = 0; _i120_0 < (200); ++_i120_0 ) {
			cv_cnv_endian_unsigned_long( &_ecnv_target_->seqctrlptr[_i120_0] );
		}
	}
}

void
cv_cnv_endian_KS_SEQ_COLLECTION( KS_SEQ_COLLECTION *_ecnv_target_ ) {
	cv_cnv_endian_struct__seq_collection_s( (struct _seq_collection_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__sar_s( struct _sar_s *_ecnv_target_ )
{
	cv_cnv_endian_double( &_ecnv_target_->average );
	cv_cnv_endian_double( &_ecnv_target_->coil );
	cv_cnv_endian_double( &_ecnv_target_->peak );
	cv_cnv_endian_double( &_ecnv_target_->b1rms );
}

void
cv_cnv_endian_KS_SAR( KS_SAR *_ecnv_target_ ) {
	cv_cnv_endian_struct__sar_s( (struct _sar_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__KS_SLICE_PLAN( struct _KS_SLICE_PLAN *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->nslices );
	cv_cnv_endian_int( &_ecnv_target_->npasses );
	cv_cnv_endian_int( &_ecnv_target_->nslices_per_pass );
	{
		size_t _i121_0;
		for( _i121_0 = 0; _i121_0 < (1 * (2048)); ++_i121_0 ) {
			cv_cnv_endian_DATA_ACQ_ORDER( &_ecnv_target_->acq_order[_i121_0] );
		}
	}
}

void
cv_cnv_endian_KS_SLICE_PLAN( KS_SLICE_PLAN *_ecnv_target_ ) {
	cv_cnv_endian_struct__KS_SLICE_PLAN( (struct _KS_SLICE_PLAN *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__sms_info_s( struct _sms_info_s *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->mb_factor );
	cv_cnv_endian_float( &_ecnv_target_->slice_gap );
	cv_cnv_endian_int( &_ecnv_target_->pulse_type );
}

void
cv_cnv_endian_KS_SMS_INFO( KS_SMS_INFO *_ecnv_target_ ) {
	cv_cnv_endian_struct__sms_info_s( (struct _sms_info_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__selrf_s( struct _selrf_s *_ecnv_target_ )
{
	cv_cnv_endian_KS_RF( &_ecnv_target_->rf );
	cv_cnv_endian_float( &_ecnv_target_->slthick );
	cv_cnv_endian_float( &_ecnv_target_->crusherscale );
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->pregrad );
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->grad );
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->postgrad );
	cv_cnv_endian_KS_WAVE( &_ecnv_target_->gradwave );
	cv_cnv_endian_KS_SMS_INFO( &_ecnv_target_->sms_info );
}

void
cv_cnv_endian_KS_SELRF( KS_SELRF *_ecnv_target_ ) {
	cv_cnv_endian_struct__selrf_s( (struct _selrf_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__readtrap_s( struct _readtrap_s *_ecnv_target_ )
{
	cv_cnv_endian_KS_READ( &_ecnv_target_->acq );
	cv_cnv_endian_float( &_ecnv_target_->fov );
	cv_cnv_endian_int( &_ecnv_target_->res );
	cv_cnv_endian_int( &_ecnv_target_->rampsampling );
	cv_cnv_endian_int( &_ecnv_target_->nover );
	cv_cnv_endian_int( &_ecnv_target_->acqdelay );
	cv_cnv_endian_float( &_ecnv_target_->paddingarea );
	cv_cnv_endian_float( &_ecnv_target_->freqoffHz );
	cv_cnv_endian_float( &_ecnv_target_->area2center );
	cv_cnv_endian_int( &_ecnv_target_->time2center );
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->grad );
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->omega );
}

void
cv_cnv_endian_KS_READTRAP( KS_READTRAP *_ecnv_target_ ) {
	cv_cnv_endian_struct__readtrap_s( (struct _readtrap_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__readwave_s( struct _readwave_s *_ecnv_target_ )
{
	{
		size_t _i122_0;
		for( _i122_0 = 0; _i122_0 < (3); ++_i122_0 ) {
			cv_cnv_endian_KS_WAVE( &_ecnv_target_->grads[_i122_0] );
		}
	}
	cv_cnv_endian_KS_WAVE( &_ecnv_target_->omega );
	cv_cnv_endian_KS_WAVE( &_ecnv_target_->theta );
	cv_cnv_endian_KS_READ( &_ecnv_target_->acq );
	{
		size_t _i123_0;
		for( _i123_0 = 0; _i123_0 < (3); ++_i123_0 ) {
			cv_cnv_endian_int( &_ecnv_target_->delay[_i123_0] );
		}
	}
	{
		size_t _i124_0;
		for( _i124_0 = 0; _i124_0 < (3); ++_i124_0 ) {
			cv_cnv_endian_float( &_ecnv_target_->amp[_i124_0] );
		}
	}
	cv_cnv_endian_float( &_ecnv_target_->freqoffHz );
	cv_cnv_endian_float( &_ecnv_target_->fov );
	cv_cnv_endian_int( &_ecnv_target_->res );
	cv_cnv_endian_int( &_ecnv_target_->rampsampling );
	cv_cnv_endian_int( &_ecnv_target_->nover );
}

void
cv_cnv_endian_KS_READWAVE( KS_READWAVE *_ecnv_target_ ) {
	cv_cnv_endian_struct__readwave_s( (struct _readwave_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__phase_s( struct _phase_s *_ecnv_target_ )
{
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->grad );
	cv_cnv_endian_float( &_ecnv_target_->fov );
	cv_cnv_endian_int( &_ecnv_target_->res );
	cv_cnv_endian_int( &_ecnv_target_->nover );
	cv_cnv_endian_int( &_ecnv_target_->R );
	cv_cnv_endian_int( &_ecnv_target_->nacslines );
	cv_cnv_endian_float( &_ecnv_target_->areaoffset );
	cv_cnv_endian_int( &_ecnv_target_->numlinestoacq );
	{
		size_t _i125_0;
		for( _i125_0 = 0; _i125_0 < (1025); ++_i125_0 ) {
			cv_cnv_endian_int( &_ecnv_target_->linetoacq[_i125_0] );
		}
	}
}

void
cv_cnv_endian_KS_PHASER( KS_PHASER *_ecnv_target_ ) {
	cv_cnv_endian_struct__phase_s( (struct _phase_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__3dphaseencodingplan_coord_s( struct _3dphaseencodingplan_coord_s *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->ky );
	cv_cnv_endian_int( &_ecnv_target_->kz );
}

void
cv_cnv_endian_KS_PHASEENCODING_COORD( KS_PHASEENCODING_COORD *_ecnv_target_ ) {
	cv_cnv_endian_struct__3dphaseencodingplan_coord_s( (struct _3dphaseencodingplan_coord_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__3dphaseencodingplan_s( struct _3dphaseencodingplan_s *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->num_shots );
	cv_cnv_endian_int( &_ecnv_target_->etl );
	cv_cnv_endian_KS_DESCRIPTION( &_ecnv_target_->description );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->entries );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->phaser );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->zphaser );
	cv_cnv_endian_int( &_ecnv_target_->is_cleared_on_tgt );
}

void
cv_cnv_endian_KS_PHASEENCODING_PLAN( KS_PHASEENCODING_PLAN *_ecnv_target_ ) {
	cv_cnv_endian_struct__3dphaseencodingplan_s( (struct _3dphaseencodingplan_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__epi_s( struct _epi_s *_ecnv_target_ )
{
	cv_cnv_endian_KS_READTRAP( &_ecnv_target_->read );
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->readphaser );
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->blip );
	cv_cnv_endian_KS_PHASER( &_ecnv_target_->blipphaser );
	cv_cnv_endian_KS_PHASER( &_ecnv_target_->zphaser );
	cv_cnv_endian_int( &_ecnv_target_->etl );
	cv_cnv_endian_int( &_ecnv_target_->read_spacing );
	cv_cnv_endian_int( &_ecnv_target_->duration );
	cv_cnv_endian_int( &_ecnv_target_->time2center );
	cv_cnv_endian_float( &_ecnv_target_->blipoversize );
	cv_cnv_endian_float( &_ecnv_target_->minbliparea );
}

void
cv_cnv_endian_KS_EPI( KS_EPI *_ecnv_target_ ) {
	cv_cnv_endian_struct__epi_s( (struct _epi_s *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__dixon_dualreadtrap_s( struct _dixon_dualreadtrap_s *_ecnv_target_ )
{
	cv_cnv_endian_KS_READWAVE( &_ecnv_target_->readwave );
	cv_cnv_endian_KS_DESCRIPTION( &_ecnv_target_->description );
	cv_cnv_endian_int( &_ecnv_target_->available_acq_time );
	cv_cnv_endian_int( &_ecnv_target_->spare_time_pre );
	cv_cnv_endian_int( &_ecnv_target_->spare_time_post );
	cv_cnv_endian_int( &_ecnv_target_->allowed_overflow_post );
	cv_cnv_endian_float( &_ecnv_target_->paddingarea );
	cv_cnv_endian_int( &_ecnv_target_->min_nover );
	{
		size_t _i126_0;
		for( _i126_0 = 0; _i126_0 < (2); ++_i126_0 ) {
			cv_cnv_endian_int( &_ecnv_target_->shifts[_i126_0] );
		}
	}
	cv_cnv_endian_int( &_ecnv_target_->nover );
	cv_cnv_endian_float( &_ecnv_target_->area2center );
	cv_cnv_endian_int( &_ecnv_target_->time2center );
	cv_cnv_endian_int( &_ecnv_target_->overflow_post );
	cv_cnv_endian_int( &_ecnv_target_->acqdelay );
	cv_cnv_endian_float( &_ecnv_target_->nsa );
	cv_cnv_endian_float( &_ecnv_target_->efficiency );
	{
		size_t _i127_0;
		for( _i127_0 = 0; _i127_0 < (4); ++_i127_0 ) {
			cv_cnv_endian_int( &_ecnv_target_->rampsampling[_i127_0] );
		}
	}
}

void
cv_cnv_endian_KS_DIXON_DUALREADTRAP( KS_DIXON_DUALREADTRAP *_ecnv_target_ ) {
	cv_cnv_endian_struct__dixon_dualreadtrap_s( (struct _dixon_dualreadtrap_s *)_ecnv_target_ );
}

void
cv_cnv_endian_enum_ks_enum_trapparts( enum ks_enum_trapparts *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_enum_ks_enum_boarddef( enum ks_enum_boarddef *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_ks_enum_epiblipsign( ks_enum_epiblipsign *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_enum_ks_enum_diffusion( enum ks_enum_diffusion *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_enum_ks_enum_imsize( enum ks_enum_imsize *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_enum_ks_enum_datadestination( enum ks_enum_datadestination *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_enum_ks_enum_accelmenu( enum ks_enum_accelmenu *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_enum_ks_enum_rfrole( enum ks_enum_rfrole *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_enum_ks_enum_sincwin( enum ks_enum_sincwin *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_enum_ks_enum_wavebuf( enum ks_enum_wavebuf *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_enum_ks_enum_smstype( enum ks_enum_smstype *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_enum_ks_enum_sms_phase_mod( enum ks_enum_sms_phase_mod *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_enum_ks_enum_grad_scaling_policy( enum ks_enum_grad_scaling_policy *_ecnv_target_ )
{
	cv_cnv_endian_int((int *) _ecnv_target_);
}

void
cv_cnv_endian_struct__KSSPSAT_VOLBORDER( struct _KSSPSAT_VOLBORDER *_ecnv_target_ )
{
	cv_cnv_endian_float( &_ecnv_target_->freq_min );
	cv_cnv_endian_float( &_ecnv_target_->freq_max );
	cv_cnv_endian_float( &_ecnv_target_->phase_min );
	cv_cnv_endian_float( &_ecnv_target_->phase_max );
	cv_cnv_endian_float( &_ecnv_target_->slice_min );
	cv_cnv_endian_float( &_ecnv_target_->slice_max );
}

void
cv_cnv_endian_KSSPSAT_VOLBORDER( KSSPSAT_VOLBORDER *_ecnv_target_ ) {
	cv_cnv_endian_struct__KSSPSAT_VOLBORDER( (struct _KSSPSAT_VOLBORDER *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__KSSPSAT_LOC( struct _KSSPSAT_LOC *_ecnv_target_ )
{
	cv_cnv_endian_SCAN_INFO( &_ecnv_target_->loc );
	cv_cnv_endian_float( &_ecnv_target_->thickness );
	cv_cnv_endian_int( &_ecnv_target_->gradboard );
	cv_cnv_endian_int( &_ecnv_target_->active );
}

void
cv_cnv_endian_KSSPSAT_LOC( KSSPSAT_LOC *_ecnv_target_ ) {
	cv_cnv_endian_struct__KSSPSAT_LOC( (struct _KSSPSAT_LOC *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__KSSPSAT_PARAMS( struct _KSSPSAT_PARAMS *_ecnv_target_ )
{
	cv_cnv_endian_KSSPSAT_VOLBORDER( &_ecnv_target_->volborder );
	cv_cnv_endian_float( &_ecnv_target_->flip );
	cv_cnv_endian_int( &_ecnv_target_->rftype );
	cv_cnv_endian_float( &_ecnv_target_->spoilerscale );
	cv_cnv_endian_int( &_ecnv_target_->spoilallaxes );
	cv_cnv_endian_int( &_ecnv_target_->oblmethod );
	cv_cnv_endian_int( &_ecnv_target_->ssi_time );
}

void
cv_cnv_endian_KSSPSAT_PARAMS( KSSPSAT_PARAMS *_ecnv_target_ ) {
	cv_cnv_endian_struct__KSSPSAT_PARAMS( (struct _KSSPSAT_PARAMS *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__KSSPSAT_SEQUENCE( struct _KSSPSAT_SEQUENCE *_ecnv_target_ )
{
	cv_cnv_endian_KS_BASE( &_ecnv_target_->base );
	cv_cnv_endian_KS_SEQ_CONTROL( &_ecnv_target_->seqctrl );
	cv_cnv_endian_KSSPSAT_LOC( &_ecnv_target_->satlocation );
	cv_cnv_endian_KS_SELRF( &_ecnv_target_->selrf );
}

void
cv_cnv_endian_KSSPSAT_SEQUENCE( KSSPSAT_SEQUENCE *_ecnv_target_ ) {
	cv_cnv_endian_struct__KSSPSAT_SEQUENCE( (struct _KSSPSAT_SEQUENCE *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__KSCHEMSAT_PARAMS( struct _KSCHEMSAT_PARAMS *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->satmode );
	cv_cnv_endian_float( &_ecnv_target_->flip );
	cv_cnv_endian_int( &_ecnv_target_->rfoffset );
	cv_cnv_endian_int( &_ecnv_target_->rftype );
	cv_cnv_endian_int( &_ecnv_target_->sincrf_bw );
	cv_cnv_endian_int( &_ecnv_target_->sincrf_tbp );
	cv_cnv_endian_float( &_ecnv_target_->spoilerarea );
	cv_cnv_endian_int( &_ecnv_target_->ssi_time );
}

void
cv_cnv_endian_KSCHEMSAT_PARAMS( KSCHEMSAT_PARAMS *_ecnv_target_ ) {
	cv_cnv_endian_struct__KSCHEMSAT_PARAMS( (struct _KSCHEMSAT_PARAMS *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__KSCHEMSAT_SEQUENCE( struct _KSCHEMSAT_SEQUENCE *_ecnv_target_ )
{
	cv_cnv_endian_KS_BASE( &_ecnv_target_->base );
	cv_cnv_endian_KS_SEQ_CONTROL( &_ecnv_target_->seqctrl );
	cv_cnv_endian_KSCHEMSAT_PARAMS( &_ecnv_target_->params );
	cv_cnv_endian_KS_RF( &_ecnv_target_->rf );
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->spoiler );
}

void
cv_cnv_endian_KSCHEMSAT_SEQUENCE( KSCHEMSAT_SEQUENCE *_ecnv_target_ ) {
	cv_cnv_endian_struct__KSCHEMSAT_SEQUENCE( (struct _KSCHEMSAT_SEQUENCE *)_ecnv_target_ );
}

void
cv_cnv_endian_KSINV_LOOP_MODE( KSINV_LOOP_MODE *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_struct__KSINV_PARAMS( struct _KSINV_PARAMS *_ecnv_target_ )
{
	cv_cnv_endian_int( &_ecnv_target_->irmode );
	cv_cnv_endian_float( &_ecnv_target_->flip );
	cv_cnv_endian_float( &_ecnv_target_->slthick );
	cv_cnv_endian_int( &_ecnv_target_->rfoffset );
	cv_cnv_endian_int( &_ecnv_target_->rftype );
	cv_cnv_endian_float( &_ecnv_target_->spoilerarea );
	cv_cnv_endian_int( &_ecnv_target_->approxti );
	cv_cnv_endian_int( &_ecnv_target_->startpos );
	cv_cnv_endian_int( &_ecnv_target_->nslicesahead );
	cv_cnv_endian_int( &_ecnv_target_->nflairslices );
	cv_cnv_endian_int( &_ecnv_target_->ssi_time );
	cv_cnv_endian_float( &_ecnv_target_->flip_exc );
	cv_cnv_endian_float( &_ecnv_target_->slthick_exc );
	cv_cnv_endian_int( &_ecnv_target_->N_Refoc );
	cv_cnv_endian_int( &_ecnv_target_->t2prep_TE );
	cv_cnv_endian_int( &_ecnv_target_->rftype_refoc );
}

void
cv_cnv_endian_KSINV_PARAMS( KSINV_PARAMS *_ecnv_target_ ) {
	cv_cnv_endian_struct__KSINV_PARAMS( (struct _KSINV_PARAMS *)_ecnv_target_ );
}

void
cv_cnv_endian_struct__KSINV_SEQUENCE( struct _KSINV_SEQUENCE *_ecnv_target_ )
{
	cv_cnv_endian_KS_BASE( &_ecnv_target_->base );
	cv_cnv_endian_KS_SEQ_CONTROL( &_ecnv_target_->seqctrl );
	cv_cnv_endian_KSINV_PARAMS( &_ecnv_target_->params );
	cv_cnv_endian_KS_SELRF( &_ecnv_target_->selrfinv );
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->spoiler );
	cv_cnv_endian_KS_SELRF( &_ecnv_target_->selrfexc );
	cv_cnv_endian_KS_SELRF( &_ecnv_target_->selrfflip );
	cv_cnv_endian_KS_SELRF( &_ecnv_target_->selrfrefoc );
}

void
cv_cnv_endian_KSINV_SEQUENCE( KSINV_SEQUENCE *_ecnv_target_ ) {
	cv_cnv_endian_struct__KSINV_SEQUENCE( (struct _KSINV_SEQUENCE *)_ecnv_target_ );
}

void
cv_cnv_endian_DIFFSCHEME( DIFFSCHEME *_ecnv_target_ ) {
	{
		size_t _i128_0, _i128_1;
		for( _i128_0 = 0; _i128_0 < (3); ++_i128_0 )
		for( _i128_1 = 0; _i128_1 < (1024); ++_i128_1 ) {
			cv_cnv_endian_float( (float *)&((*_ecnv_target_)[_i128_0][_i128_1]) );
		}
	}
}

void
cv_cnv_endian_OFFLINE_DIFFRETURN_MODE( OFFLINE_DIFFRETURN_MODE *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

void
cv_cnv_endian_struct_KSEPI_SEQUENCE( struct KSEPI_SEQUENCE *_ecnv_target_ )
{
	cv_cnv_endian_KS_SEQ_CONTROL( &_ecnv_target_->seqctrl );
	cv_cnv_endian_KS_EPI( &_ecnv_target_->epitrain );
	cv_cnv_endian_KS_EPI( &_ecnv_target_->epireftrain );
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->spoiler );
	cv_cnv_endian_KS_SELRF( &_ecnv_target_->selrfexc );
	cv_cnv_endian_KS_SELRF( &_ecnv_target_->selrfref );
	cv_cnv_endian_KS_SELRF( &_ecnv_target_->selrfref2 );
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->diffgrad );
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->diffgrad2 );
	cv_cnv_endian_KS_WAIT( &_ecnv_target_->pre_delay );
	cv_cnv_endian_KS_WAIT( &_ecnv_target_->post_delay );
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->fcompphase );
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->fcompslice );
	cv_cnv_endian_KS_PHASEENCODING_PLAN( &_ecnv_target_->full_peplan );
	cv_cnv_endian_KS_PHASEENCODING_PLAN( &_ecnv_target_->ref_peplan );
	cv_cnv_endian_KS_PHASEENCODING_PLAN( &_ecnv_target_->peplan );
	cv_cnv_endian_unsigned_long( &_ecnv_target_->current_peplan );
}

void
cv_cnv_endian_KSEPI_SEQUENCE( KSEPI_SEQUENCE *_ecnv_target_ ) {
	cv_cnv_endian_struct_KSEPI_SEQUENCE( (struct KSEPI_SEQUENCE *)_ecnv_target_ );
}

void
cv_cnv_endian_struct_KSEPI_FLEET_SEQUENCE( struct KSEPI_FLEET_SEQUENCE *_ecnv_target_ )
{
	cv_cnv_endian_KS_SEQ_CONTROL( &_ecnv_target_->seqctrl );
	cv_cnv_endian_KS_EPI( &_ecnv_target_->epitrain );
	cv_cnv_endian_KS_TRAP( &_ecnv_target_->spoiler );
	cv_cnv_endian_KS_SELRF( &_ecnv_target_->selrfexc );
	cv_cnv_endian_KS_WAIT( &_ecnv_target_->pre_delay );
	cv_cnv_endian_KS_WAIT( &_ecnv_target_->post_delay );
	cv_cnv_endian_KS_PHASEENCODING_PLAN( &_ecnv_target_->peplan );
}

void
cv_cnv_endian_KSEPI_FLEET_SEQUENCE( KSEPI_FLEET_SEQUENCE *_ecnv_target_ ) {
	cv_cnv_endian_struct_KSEPI_FLEET_SEQUENCE( (struct KSEPI_FLEET_SEQUENCE *)_ecnv_target_ );
}

void
cv_cnv_endian_KSEPI_MULTISHOT_MODE( KSEPI_MULTISHOT_MODE *_ecnv_target_ ) {
	cv_cnv_endian_int( (int *) _ecnv_target_ );
}

