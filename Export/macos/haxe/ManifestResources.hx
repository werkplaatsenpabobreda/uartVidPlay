package;

import haxe.io.Bytes;
import haxe.io.Path;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

#if disable_preloader_assets
@:dox(hide) class ManifestResources {
	public static var preloadLibraries:Array<Dynamic>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;

	public static function init (config:Dynamic):Void {
		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();
	}
}
#else
@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

			if(!StringTools.endsWith (rootPath, "/")) {

				rootPath += "/";

			}

		}

		if (rootPath == null) {

			#if (ios || tvos || webassembly)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif (console || sys)
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		#if (openfl && !flash && !display)
		
		#end

		var data, manifest, library, bundle;

		Assets.libraryPaths["libvlc"] = rootPath + "manifest/libvlc.json";
		Assets.libraryPaths["default"] = rootPath + "manifest/default.json";
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

	}


}

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_lib_libvlccore_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_lib_libvlc_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libtospdif_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libddummy_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libtaglib_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_liblibass_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libspeex_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libi420_rgb_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmarq_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libugly_resampler_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_librawvideo_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libfreetype_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libi420_rgb_mmx_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libscreen_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libadummy_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmosaic_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaccess_concat_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libasf_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpng_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaom_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_autodel_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpsychedelic_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdolby_surround_decoder_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libequalizer_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmux_ps_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libi420_10_p010_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaes3_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libi422_yuy2_sse2_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libnormvol_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_dummy_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libscaletempo_pitch_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libinteger_mixer_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libbluray_awt_j2se_1_3_2_jar extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libxa_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaccess_srt_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libi420_yuy2_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libvideotoolbox_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libcroppadd_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libvoc_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libscte27_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libnoseek_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaccess_output_file_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libvout_macosx_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_gather_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libflaschen_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmux_ts_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libavcodec_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libedgedetection_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaddonsvorepository_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libcaopengllayer_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libedummy_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libbonjour_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpacketizer_av1_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libcache_read_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libblendbench_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libinvert_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libvc1_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdcp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libfolder_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_record_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpacketizer_mlp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libavcapture_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libvdr_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libfaad_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdecomp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_liba52_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libvobsub_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsecuretransport_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libfreeze_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpacketizer_copy_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libscene_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libupnp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libposterize_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsubsdec_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libgestures_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libgnutls_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_transcode_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libimage_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libvmem_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_stats_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsatip_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaccess_output_dummy_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libwav_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsamplerate_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_liblpcm_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libchorus_flanger_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmux_mpjpeg_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libhotkeys_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdvdnav_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libhqdn3d_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmirror_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libflac_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libcaf_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaudio_format_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsmf_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libspatializer_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libanaglyph_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libi420_yuy2_mmx_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsap_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmono_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libx26410b_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmediadirs_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libnuv_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libalphamask_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstereo_widen_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libtwolame_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsepia_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaccess_output_udp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmux_mp4_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaudiobargraph_a_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_librawdv_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_description_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libglconv_cvpx_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libt140_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmux_ogg_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_setid_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_cycle_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libtextst_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libi422_yuy2_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmotiondetect_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaccess_output_livehttp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libi420_yuy2_sse2_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libwave_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpacketizer_dirac_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libfps_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libwebvtt_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libhttps_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libball_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpva_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libvisual_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libi422_yuy2_mmx_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_liblogo_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdiracsys_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libfingerprinter_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libcvdsub_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsharpen_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libfile_keystore_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libclone_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libgaussianblur_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libavi_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_librtp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmemory_keystore_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libyuy2_i420_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_chromaprint_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsubsusf_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdvbsub_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libkaraoke_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmotionblur_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpacketizer_flac_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libripple_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpacketizer_h264_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libwall_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsftp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libcanvas_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_librawvid_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_display_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaccess_imem_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libblend_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libvod_rtsp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libi420_nv12_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpuzzle_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_delay_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libattachment_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libnfs_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libgme_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libexport_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libskiptags_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libantiflicker_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_liblogger_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libfloat_mixer_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_es_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libxml_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaudioscrobbler_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdemux_chromecast_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libplaylist_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libgradient_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpacketizer_mpegaudio_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsubtitle_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmux_wav_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmad_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libreal_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libtransform_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libopus_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libtcp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libnsspeechsynthesizer_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libudp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libnsv_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpacketizer_vc1_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdca_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmpgv_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstl_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaddonsfsstorage_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libcdg_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libtrivial_channel_mixer_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libyuy2_i422_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_librtpvideo_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstats_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmotion_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpacketizer_dts_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libhds_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmkv_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libcolorthres_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libheadphone_channel_mixer_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmjpeg_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libtimecode_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaccess_output_http_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libgain_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmpc_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaccess_output_shout_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libzvbi_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_librotate_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libremoteosd_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libkeychain_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libcc_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libx265_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libftp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpostproc_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libconsole_logger_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_rtp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libbluescreen_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libgrain_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_librawaud_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmpg123_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpacketizer_a52_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_librss_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaccess_output_srt_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libspudec_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libarchive_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdvdread_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libty_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libi422_i420_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libvpx_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libprefetch_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libadjust_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdummy_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libbluray_j2se_1_3_2_jar extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libgoom_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpodcast_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmux_dummy_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libvhs_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libinflate_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsid_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libgrey_yuv_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmux_asf_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdemuxdump_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_liblua_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libtheora_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsdp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libvorbis_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libcvpx_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libspdif_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_liboldrc_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libscte18_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libci_filters_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsvcdsub_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaraw_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libvcd_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaccess_output_rist_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libchain_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpacketizer_mpegvideo_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libscale_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libcompressor_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libosx_notifications_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libx264_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaccess_realrtsp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libcache_block_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libadpcm_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libyuvp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libgradfun_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libcdda_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_liboldmovie_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdav1d_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libparam_eq_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaiff_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libidummy_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libhttp_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_librv32_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaudiotoolboxmidi_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libes_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libjpeg_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libnetsync_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libfilesystem_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_bridge_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libkate_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaribsub_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libps_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_liberase_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libadaptive_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_librecord_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_standard_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsubstx3g_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdeinterlace_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libuleaddvaudio_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libadf_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libschroedinger_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmux_avi_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdemux_cdg_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libimem_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_liblibbluray_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libtelx_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdemux_stl_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libts_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libextract_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpacketizer_mpeg4audio_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libremap_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaudiobargraph_v_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpacketizer_hevc_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_librist_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libfile_logger_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libtta_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdirectory_demux_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsimple_channel_mixer_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libh26x_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libg711_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_liblive555_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libttml_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libvdummy_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_liblibmpeg2_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libogg_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libau_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libnsc_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libyuv_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libafile_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_mosaic_bridge_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmp4_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libi420_rgb_sse2_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_liboggspots_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libpacketizer_mpeg4video_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libavaudiocapture_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libncurses_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libdynamicoverlay_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmacosx_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libshm_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_chromecast_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libflacsys_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libaccess_mms_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmod_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libscaletempo_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsyslog_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libmagnify_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_duplicate_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libsubsdelay_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libswscale_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libamem_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libstream_out_smem_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__file___macos_plugins_libspeex_resampler_plugin_dylib extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__data_config_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_libvlc_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)




#else



#end

#if (openfl && !flash)

#if html5

#else

#end

#end
#end

#end