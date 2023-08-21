CLASS zcl_struct_mapper DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS:
      bapi_mara_ga_to_mara IMPORTING bapi_mara_ga TYPE bapi_mara_ga RETURNING VALUE(mara) TYPE mara,
      bapi_marc_ga_to_marc IMPORTING bapi_marc_ga TYPE bapi_marc_ga currency TYPE waers_curc RETURNING VALUE(marc) TYPE marc,
      bapi_mpop_ga_to_mpop IMPORTING bapi_mpop_ga TYPE bapi_mpop_ga RETURNING VALUE(mpop) TYPE mpop,
      bapi_mpgd_ga_to_mpgd IMPORTING bapi_mpgd_ga TYPE bapi_mpgd_ga RETURNING VALUE(mpgd) TYPE mpgd,
      bapi_mard_ga_to_mard IMPORTING bapi_mard_ga TYPE bapi_mard_ga RETURNING VALUE(mard) TYPE mard,
      bapi_mbew_ga_to_mbew IMPORTING bapi_mbew_ga TYPE bapi_mbew_ga currency TYPE waers_curc RETURNING VALUE(mbew) TYPE mbew,
      bapi_mlgn_ga_to_mlgn IMPORTING bapi_mlgn_ga TYPE bapi_mlgn_ga RETURNING VALUE(mlgn) TYPE mlgn,
      bapi_mvke_ga_to_mvke IMPORTING bapi_mvke_ga TYPE bapi_mvke_ga RETURNING VALUE(mvke) TYPE mvke,
      bapi_mlgt_ga_to_mlgt IMPORTING bapi_mlgt_ga TYPE bapi_mlgt_ga RETURNING VALUE(mlgt) TYPE mlgt,
      bapi_mfhm_ga_to_mfhm IMPORTING bapi_mfhm_ga TYPE bapi_mfhm_ga RETURNING VALUE(mfhm) TYPE mfhm,
      bapi_myms_ga_to_myms IMPORTING bapi_myms_ga TYPE bapi_myms_ga RETURNING VALUE(myms) TYPE myms,
      bapi_makt_ga_to_makt IMPORTING bapi_makt_ga TYPE bapi_makt_ga RETURNING VALUE(makt) TYPE makt,
      mara_to_bapi_mara_ga IMPORTING  mara TYPE mara RETURNING VALUE(bapi_mara_ga) TYPE bapi_mara_ga,
      marc_to_bapi_marc_ga IMPORTING  marc TYPE marc RETURNING VALUE(bapi_marc_ga) TYPE bapi_marc_ga,
      mpop_to_bapi_mpop_ga IMPORTING  mpop TYPE mpop RETURNING VALUE(bapi_mpop_ga) TYPE bapi_mpop_ga,
      mpgd_to_bapi_mpgd_ga IMPORTING  mpgd TYPE mpgd RETURNING VALUE(bapi_mpgd_ga) TYPE bapi_mpgd_ga,
      mard_to_bapi_mard_ga IMPORTING  mard TYPE mard RETURNING VALUE(bapi_mard_ga) TYPE bapi_mard_ga,
      mbew_to_bapi_mbew_ga IMPORTING  mbew TYPE mbew RETURNING VALUE(bapi_mbew_ga) TYPE bapi_mbew_ga,
      mlgn_to_bapi_mlgn_ga IMPORTING  mlgn TYPE mlgn RETURNING VALUE(bapi_mlgn_ga) TYPE bapi_mlgn_ga,
      mvke_to_bapi_mvke_ga IMPORTING  mvke TYPE mvke RETURNING VALUE(bapi_mvke_ga) TYPE bapi_mvke_ga,
      mlgt_to_bapi_mlgt_ga IMPORTING  mlgt TYPE mlgt RETURNING VALUE(bapi_mlgt_ga) TYPE bapi_mlgt_ga,
      mfhm_to_bapi_mfhm_ga IMPORTING  mfhm TYPE mfhm RETURNING VALUE(bapi_mfhm_ga) TYPE bapi_mfhm_ga,
      myms_to_bapi_myms_ga IMPORTING  myms TYPE myms RETURNING VALUE(bapi_myms_ga) TYPE bapi_myms_ga,
      makt_to_bapi_makt_ga IMPORTING  makt TYPE makt RETURNING VALUE(bapi_makt_ga) TYPE bapi_makt_ga.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS:
      unit_of_measure_iso_to_sap IMPORTING iso_code TYPE t006-isocode RETURNING VALUE(sap_code) TYPE t006-msehi,
      language_code_sap_to_iso IMPORTING sap_code TYPE t002-spras RETURNING VALUE(iso_code) TYPE t002-laiso,
      currency_amount_bapi_to_sap IMPORTING currency TYPE waers_curc bapi_amount TYPE bapicurr_d RETURNING VALUE(sap_amount) TYPE bapicurr_d.
ENDCLASS.



CLASS ZCL_STRUCT_MAPPER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>BAPI_MAKT_GA_TO_MAKT
* +-------------------------------------------------------------------------------------------------+
* | [--->] BAPI_MAKT_GA                   TYPE        BAPI_MAKT_GA
* | [<-()] MAKT                           TYPE        MAKT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bapi_makt_ga_to_makt.
    makt-spras = bapi_makt_ga-langu.
    makt-maktx = bapi_makt_ga-matl_desc.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>BAPI_MARA_GA_TO_MARA
* +-------------------------------------------------------------------------------------------------+
* | [--->] BAPI_MARA_GA                   TYPE        BAPI_MARA_GA
* | [<-()] MARA                           TYPE        MARA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bapi_mara_ga_to_mara.
    "Copied and modified from FM 'MAP2E_MARA_TO_BAPI_MARA_GA' - 07.07.2023
    mara-gds_relevant = bapi_mara_ga-gds_relevant.
    mara-kzwsm = bapi_mara_ga-uomusage.
    mara-extwg = bapi_mara_ga-extmatlgrp.
    mara-rmatp = bapi_mara_ga-pl_ref_mat.
    mara-serlv = bapi_mara_ga-serialization_level.
    mara-gtin_variant = bapi_mara_ga-gtin_variant.
    mara-sled_bbd = bapi_mara_ga-sled_bbd.
    mara-cmrel = bapi_mara_ga-cm_relevance_flag.
    mara-matfi = bapi_mara_ga-material_fixed.
    mara-mtpos_mara = bapi_mara_ga-item_cat.
    mara-przus = bapi_mara_ga-prod_composition_on_packaging.
    mara-iprkz = bapi_mara_ga-period_ind_expiration_date.
    mara-rdmhd = bapi_mara_ga-round_up_rule_expiration_date.
    mara-kzeff = bapi_mara_ga-par_eff.
    mara-compl = bapi_mara_ga-matcmpllvl.
    mara-xgchp = bapi_mara_ga-appd_b_rec.
    mara-kzgvh = bapi_mara_ga-closed_box.
    mara-iloos = bapi_mara_ga-looseorliq.
    mara-ihivi = bapi_mara_ga-high_visc.
    mara-profl = bapi_mara_ga-hazmatprof.
    mara-mprof = bapi_mara_ga-manuf_prof.
    mara-bmatn = bapi_mara_ga-inv_mat_no.
    mara-mfrnr = bapi_mara_ga-mfr_no.
    mara-mfrpn = bapi_mara_ga-manu_mat.
    mara-nrfhg = bapi_mara_ga-qual_dik.
    mara-kosch = bapi_mara_ga-prod_alloc.
    mara-kzumw = bapi_mara_ga-envt_rlvt.
    mara-mstdv = bapi_mara_ga-svalidfrom.
    mara-mstde = bapi_mara_ga-pvalidfrom.
    mara-mstav = bapi_mara_ga-sal_status.
    mara-anp = bapi_mara_ga-anp.
    mara-mstae = bapi_mara_ga-pur_status.
    mara-sgt_rel = bapi_mara_ga-segmentation_relevance.
    mara-sgt_covsa = bapi_mara_ga-segmentation_strategy.
    mara-sgt_csgr = bapi_mara_ga-segmentation_structure.
    mara-commodity = bapi_mara_ga-physical_commodity.
    mara-nsnid = bapi_mara_ga-nsnid.
    mara-medium = bapi_mara_ga-medium.
    mara-ipmipproduct = bapi_mara_ga-ipmipproduct.
    mara-adprof = bapi_mara_ga-adjust_profile.
    mara-dg_pack_status = bapi_mara_ga-dg_pckging_status.
    mara-packcode = bapi_mara_ga-pacod.
    mara-cwqproc = bapi_mara_ga-ewm_cw_input_control.
    mara-cwqtolgr = bapi_mara_ga-ewm_cw_tolerance_group.
    mara-cwqrel = bapi_mara_ga-ewm_cw_relevant.
    mara-serial = bapi_mara_ga-serial_number_profile.
    mara-qgrp = bapi_mara_ga-quality_insp_grp.
    mara-qqtime = bapi_mara_ga-quarantine_period.
    mara-mfrgr = bapi_mara_ga-matfrgtgrp.
    mara-maxh = bapi_mara_ga-max_allowed_heigth.
    mara-maxb = bapi_mara_ga-max_allowed_width.
    mara-maxl = bapi_mara_ga-max_allowed_length.
    mara-maxc_tol = bapi_mara_ga-overcapacity_tolerance.
    mara-maxc = bapi_mara_ga-max_allowed_capacity.
    mara-tare_var = bapi_mara_ga-variable_tare_weight.
    mara-hutyp = bapi_mara_ga-hu_type.
    mara-hazmat = bapi_mara_ga-haz_mat_relevant.
    mara-hndlcode = bapi_mara_ga-handling_indicator.
    mara-whmatgr = bapi_mara_ga-whse_material_group.
    mara-whstc = bapi_mara_ga-whse_storage_condition.
    mara-pilferable = bapi_mara_ga-pilferable.
    mara-hutyp_dflt = bapi_mara_ga-std_hu_type.
    mara-weora = bapi_mara_ga-we_origin_acceptance.
    mara-tragr = bapi_mara_ga-trans_grp.
    mara-tempb = bapi_mara_ga-temp_conds.
    mara-raube = bapi_mara_ga-stor_conds.
    mara-behvo = bapi_mara_ga-container.
    mara-ntgew = bapi_mara_ga-net_weight.
    mara-ekwsl = bapi_mara_ga-pur_valkey.
    mara-labor = bapi_mara_ga-dsn_office.
    mara-normt = bapi_mara_ga-std_descr.
    mara-wrkst = bapi_mara_ga-basic_matl.
    mara-groes = bapi_mara_ga-size_dim.
    mara-formt = bapi_mara_ga-pageformat.
    mara-ferth = bapi_mara_ga-prod_memo.
    mara-blanz = bapi_mara_ga-no_sheets.
    mara-blatt = bapi_mara_ga-page_no.
    mara-aeszn = bapi_mara_ga-doc_chg_no.
    mara-zeifo = bapi_mara_ga-doc_format.
    mara-zeivr = bapi_mara_ga-doc_vers.
    mara-zeiar = bapi_mara_ga-doc_type.
    mara-zeinr = bapi_mara_ga-document.
    mara-bismt = bapi_mara_ga-old_mat_no.
    mara-matkl = bapi_mara_ga-matl_group.
    mara-lvorm = bapi_mara_ga-del_flag.
    mara-pstat = bapi_mara_ga-maint_stat.
    mara-vpsta = bapi_mara_ga-mat_status.
    mara-aenam = bapi_mara_ga-changed_by.
    mara-laeda = bapi_mara_ga-last_chnge.
    mara-ernam = bapi_mara_ga-created_by.
    mara-ersda = bapi_mara_ga-created_on.
    mara-mtart = bapi_mara_ga-matl_type.
    mara-mbrsh = bapi_mara_ga-ind_sector.
    mara-matnr = bapi_mara_ga-material.
    mara-pmata = bapi_mara_ga-pr_ref_mat.
    mara-kzkup = bapi_mara_ga-co_product.
    mara-satnr = bapi_mara_ga-conf_matl.
    mara-mhdlp = bapi_mara_ga-stor_pct.
    mara-mhdhb = bapi_mara_ga-shelf_life.
    mara-mhdrz = bapi_mara_ga-minremlife.
    mara-rbnrm = bapi_mara_ga-catprofile.
    mara-qmpur = bapi_mara_ga-qm_procmnt.
    mara-begru = bapi_mara_ga-authoritygroup.
    mara-magrv = bapi_mara_ga-mat_grp_sm.
    mara-stfak = bapi_mara_ga-stack_fact.
    mara-fuelg = bapi_mara_ga-fill_level.
    mara-vhart = bapi_mara_ga-sh_mat_typ.
    mara-xchpf = bapi_mara_ga-batch_mgmt.
    mara-kzkfg = bapi_mara_ga-configured.
    mara-vabme = bapi_mara_ga-var_ord_un.
    mara-volto = bapi_mara_ga-vol_tol_lt.
    mara-gewto = bapi_mara_ga-wt_tol_lt.
    mara-ervol = bapi_mara_ga-allwd_vol.
    mara-ergew = bapi_mara_ga-allowed_wt.
    mara-cadkz = bapi_mara_ga-cad_id.
    mara-prdha = bapi_mara_ga-prod_hier.
    mara-etifo = bapi_mara_ga-label_form.
    mara-etiar = bapi_mara_ga-label_type.
    mara-saiso = bapi_mara_ga-season.
    mara-bwscl = bapi_mara_ga-sup_source.
    mara-bwvor = bapi_mara_ga-proc_rule.
    mara-wesch = bapi_mara_ga-qty_gr_gi.
    mara-kunnr = bapi_mara_ga-competitor.
    mara-spart = bapi_mara_ga-division.
    mara-stoff = bapi_mara_ga-haz_mat_no.

    mara-herkl  = bapi_mara_ga-countryori.
    mara-logunit  =  bapi_mara_ga-ewm_cw_logistical_unit.
    mara-qqtimeuom  =  bapi_mara_ga-quarantine_period_un .
    mara-meins  = bapi_mara_ga-base_uom .
    mara-bstme  =  bapi_mara_ga-po_unit .
    mara-maxdim_uom  = bapi_mara_ga-max_dimension_un .
    mara-gewei  =  bapi_mara_ga-unit_of_wt .
    mara-ergei  =  bapi_mara_ga-pack_wt_un .
    mara-ervoe  =  bapi_mara_ga-pack_vo_un .
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>BAPI_MARC_GA_TO_MARC
* +-------------------------------------------------------------------------------------------------+
* | [--->] BAPI_MARC_GA                   TYPE        BAPI_MARC_GA
* | [--->] CURRENCY                       TYPE        WAERS_CURC
* | [<-()] MARC                           TYPE        MARC
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bapi_marc_ga_to_marc.
    "Copied and modified from FM 'MAP2E_MARC_TO_BAPI_MARC_GA' - 07.07.2023
    marc-mmstd = bapi_marc_ga-pvalidfrom.
    marc-kzech = bapi_marc_ga-batchentry.
    marc-mdach = bapi_marc_ga-plord_ctrl.
    marc-shzet = bapi_marc_ga-safetytime.
    marc-shflg = bapi_marc_ga-safty_t_id.
    marc-sfcpf = bapi_marc_ga-prodprof.
    marc-mmsta = bapi_marc_ga-pur_status.
    marc-plnty = bapi_marc_ga-task_list_type.
    marc-qmata = bapi_marc_ga-qm_authgrp.
    marc-eprio = bapi_marc_ga-determ_grp.
    marc-ccfix = bapi_marc_ga-cc_fixed.
    marc-schgt = bapi_marc_ga-bulk_mat.
    marc-lgfsb = bapi_marc_ga-sloc_exprc.
    marc-strgr = bapi_marc_ga-plan_strgp.
    marc-kzkup = bapi_marc_ga-co_product.
    marc-prfrq = bapi_marc_ga-insp_int.
    marc-itark = bapi_marc_ga-milit_id.
    marc-prene = bapi_marc_ga-decl_stat_flag.
    marc-prend = bapi_marc_ga-ex_cert_dt.
    marc-preno = bapi_marc_ga-ex_cert_no_new.
    marc-prenc = bapi_marc_ga-ex_cert_id.
    marc-prefe = bapi_marc_ga-pref_stat_flag.
    marc-autru = bapi_marc_ga-auto_reset.
    marc-vrbfk = bapi_marc_ga-mult_ref_m.
    marc-vrbdt = bapi_marc_ga-d_to_ref_m.
    marc-vrbwk = bapi_marc_ga-refpltcons.
    marc-vrbmt = bapi_marc_ga-refmatcons.
    marc-rdprf = bapi_marc_ga-round_prof.
    marc-lfrhy = bapi_marc_ga-plng_cycle.
    marc-qssys = bapi_marc_ga-qm_rgmts.
    marc-xmcng = bapi_marc_ga-neg_stocks.
    marc-sfepr = bapi_marc_ga-repmanprof.
    marc-stdpd = bapi_marc_ga-ps_conf_mat.
    marc-sernp = bapi_marc_ga-serno_prof.
    marc-awsls = bapi_marc_ga-variance_key.
    marc-abcin = bapi_marc_ga-cc_ph_inv.
    marc-rwpro = bapi_marc_ga-covprofile.
    marc-qmatv = bapi_marc_ga-insp_setup_flag.
    marc-takzt = bapi_marc_ga-cycle_time.
    marc-qzgtp = bapi_marc_ga-cert_type.
    marc-kausf = bapi_marc_ga-comp_scrap.
    marc-disgr = bapi_marc_ga-mrp_group.
    marc-mfrgr = bapi_marc_ga-matfrgtgrp.
    marc-ppskz = bapi_marc_ga-adv_plng_ind.
    marc-sgt_defsc = bapi_marc_ga-default_stock_segment.
    marc-sgt_stk_prt = bapi_marc_ga-stock_protection_ind.
    marc-sgt_chint = bapi_marc_ga-discrete_batch_flag.
    marc-sgt_prcm = bapi_marc_ga-consumption_priority.
    marc-sgt_statc = bapi_marc_ga-segmentation_status.
    marc-sgt_covs = bapi_marc_ga-segmentation_strategy.
    marc-uid_iea = bapi_marc_ga-uid_iea.
    marc-iuid_type = bapi_marc_ga-iuid_type.
    marc-iuid_relevant = bapi_marc_ga-iuid_relevant.
    marc-ucmat = bapi_marc_ga-original_batch_ref_material.
    marc-uchkz = bapi_marc_ga-original_batch_flag.
    marc-rotation_date = bapi_marc_ga-rotation_date.
    marc-megru = bapi_marc_ga-unit_group.
    marc-ncost = bapi_marc_ga-no_costing.
    marc-eislo = bapi_marc_ga-min_safety_stk.
    marc-diber = bapi_marc_ga-mrp_area_exists.
    marc-ahdis = bapi_marc_ga-mrp_relevancy_dep_requirements.
    marc-ocmpf = bapi_marc_ga-overallprf.
    marc-kzpsp = bapi_marc_ga-avail_check_all_proj_segments.
    marc-fxpru = bapi_marc_ga-fxd_price.
    marc-shpro = bapi_marc_ga-period_profile_safety_time.
    marc-fprfm = bapi_marc_ga-distr_prof.
    marc-convt = bapi_marc_ga-prod_conv_type.
    marc-ltinc = bapi_marc_ga-lot_increment.
    marc-fixls = bapi_marc_ga-fix_lot_size.
    marc-maxls = bapi_marc_ga-max_lot_size.
    marc-minls = bapi_marc_ga-min_lot_size.
    marc-dplho = bapi_marc_ga-deploy_horiz.
    marc-dplpu = bapi_marc_ga-push_distrib.
    marc-dplfs = bapi_marc_ga-fair_share_rule.
    marc-vspvb = bapi_marc_ga-supply_area.
    marc-loggr = bapi_marc_ga-handlg_grp.
    marc-matgr = bapi_marc_ga-mat_grp_trans.
    marc-fabkz = bapi_marc_ga-jit_relvt.
    marc-steuc = bapi_marc_ga-ctrl_code.
    marc-gpnum = bapi_marc_ga-prodcom_no.
    marc-casnr = bapi_marc_ga-cas_no.
    marc-mogru = bapi_marc_ga-eu_mat_grp.
    marc-mownr = bapi_marc_ga-eu_list_no.
    marc-indus = bapi_marc_ga-mat_cfop.
    marc-fvidk = bapi_marc_ga-prodverscs.
    marc-ueeto = bapi_marc_ga-over_tol.
    marc-maxlz = bapi_marc_ga-stgeperiod.
    marc-dzeit = bapi_marc_ga-inhseprodt.
    marc-basmg = bapi_marc_ga-base_qty.
    marc-tranz = bapi_marc_ga-interop.
    marc-ruezt = bapi_marc_ga-setuptime.
    marc-bearz = bapi_marc_ga-proc_time.
    marc-fevor = bapi_marc_ga-production_scheduler.
    marc-rgekz = bapi_marc_ga-backflush.
    marc-fhori = bapi_marc_ga-sm_key.
    marc-miskz = bapi_marc_ga-mixed_mrp.
    marc-kzbed = bapi_marc_ga-grp_reqmts.
    marc-nfmat = bapi_marc_ga-follow_up.
    marc-ausdt = bapi_marc_ga-eff_o_day.
    marc-kzaus = bapi_marc_ga-discontinu.
    marc-altsl = bapi_marc_ga-alt_bom_id.
    marc-lagpr = bapi_marc_ga-stor_costs.
    marc-sbdkz = bapi_marc_ga-dep_req_id.
    marc-mabst = bapi_marc_ga-max_stock.
    marc-bstrf = bapi_marc_ga-round_val.
    marc-bstfe = bapi_marc_ga-fixed_lot.
    marc-bstma = bapi_marc_ga-maxlotsize.
    marc-bstmi = bapi_marc_ga-minlotsize.
    marc-eisbe = bapi_marc_ga-safety_stk.
    marc-minbe = bapi_marc_ga-reorder_pt.
    marc-sobsl = bapi_marc_ga-spproctype.
    marc-beskz = bapi_marc_ga-proc_type.
    marc-disls = bapi_marc_ga-lotsizekey.
    marc-ausss = bapi_marc_ga-assy_scrap.
    marc-perkz = bapi_marc_ga-period_ind.
    marc-webaz = bapi_marc_ga-gr_pr_time.
    marc-plifz = bapi_marc_ga-plnd_delry.
    marc-dispo = bapi_marc_ga-mrp_ctrler.
    marc-dismm = bapi_marc_ga-mrp_type.
    marc-dispr = bapi_marc_ga-mrpprofile.
    marc-ekgrp = bapi_marc_ga-pur_group.
    marc-kzkri = bapi_marc_ga-crit_part.
    marc-maabc = bapi_marc_ga-abc_id.
    marc-lvorm = bapi_marc_ga-del_flag.
    marc-pstat = bapi_marc_ga-maint_stat.
    marc-werks = bapi_marc_ga-plant.
    marc-ueetk = bapi_marc_ga-unlimited.
    marc-lgpro = bapi_marc_ga-iss_st_loc.
    marc-sobsk = bapi_marc_ga-specprocty.
    marc-losgr = bapi_marc_ga-lot_size.
    marc-aplal = bapi_marc_ga-planlistcnt.
    marc-plnnr = bapi_marc_ga-planlistgrp.
    marc-stlan = bapi_marc_ga-bom_usage.
    marc-stlal = bapi_marc_ga-alternative_bom.
    marc-verkz = bapi_marc_ga-version_flag.
    marc-vint2 = bapi_marc_ga-fwd_cons.
    marc-vint1 = bapi_marc_ga-bwd_cons.
    marc-vrmod = bapi_marc_ga-consummode.
    marc-fxhor = bapi_marc_ga-pl_ti_fnce.
    marc-sauft = bapi_marc_ga-rep_manuf.
    marc-mrppp = bapi_marc_ga-ppc_pl_cal.
    marc-prctr = bapi_marc_ga-profit_ctr.
    marc-mtver = bapi_marc_ga-expimpgrp.
    marc-herkr = bapi_marc_ga-regionorig.
    marc-stawn = bapi_marc_ga-comm_code.
    marc-kordb = bapi_marc_ga-sourcelist.
    marc-kautb = bapi_marc_ga-auto_p_ord.
    marc-uneto = bapi_marc_ga-under_tol.
    marc-wzeit = bapi_marc_ga-replentime.
    marc-atpkz = bapi_marc_ga-replace_pt.
    marc-insmk = bapi_marc_ga-ind_post_to_insp_stock.
    marc-ssqss = bapi_marc_ga-ctrl_key.
    marc-kzdkz = bapi_marc_ga-doc_reqd.
    marc-ladgr = bapi_marc_ga-loadinggrp.
    marc-xchpf = bapi_marc_ga-batch_mgmt.
    marc-usequ = bapi_marc_ga-quotausage.
    marc-lgrad = bapi_marc_ga-serv_level.
    marc-auftl = bapi_marc_ga-split_ind.
    marc-mtvfp = bapi_marc_ga-availcheck.
    marc-periv = bapi_marc_ga-fy_variant.
    marc-kzkfk = bapi_marc_ga-corr_fact.
    marc-vrvez = bapi_marc_ga-setup_time.
    marc-vbamg = bapi_marc_ga-base_qty_plan.
    marc-vbeaz = bapi_marc_ga-ship_proc_time.
    marc-bwscl = bapi_marc_ga-sup_source.

    marc-herkl = bapi_marc_ga-countryori.
    marc-expme = bapi_marc_ga-comm_co_un.
    marc-ausme = bapi_marc_ga-issue_unit.
    marc-lzeih = bapi_marc_ga-stge_pd_un.
    marc-frtme = bapi_marc_ga-prod_unit.

    marc-losfx = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_marc_ga-ord_costs ) ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>BAPI_MARD_GA_TO_MARD
* +-------------------------------------------------------------------------------------------------+
* | [--->] BAPI_MARD_GA                   TYPE        BAPI_MARD_GA
* | [<-()] MARD                           TYPE        MARD
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bapi_mard_ga_to_mard.
    "Copied and modified from FM 'MAP2E_MARD_TO_BAPI_MARD_GA' - 10.07.2023
    mard-bskrf = bapi_mard_ga-inv_corr_fac.
    mard-lwmkb = bapi_mard_ga-pickg_area.
    mard-lgpbe = bapi_mard_ga-stge_bin.
    mard-lbstf = bapi_mard_ga-repl_qty.
    mard-lminb = bapi_mard_ga-reorder_pt.
    mard-lsobs = bapi_mard_ga-spec_proc.
    mard-diskz = bapi_mard_ga-mrp_ind.
    mard-lfmon = bapi_mard_ga-curr_period.
    mard-lfgja = bapi_mard_ga-fisc_year.
    mard-lvorm = bapi_mard_ga-del_flag.
    mard-pstat = bapi_mard_ga-maint_stat.
    mard-lgort = bapi_mard_ga-stge_loc.
    mard-werks = bapi_mard_ga-plant.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>BAPI_MBEW_GA_TO_MBEW
* +-------------------------------------------------------------------------------------------------+
* | [--->] BAPI_MBEW_GA                   TYPE        BAPI_MBEW_GA
* | [--->] CURRENCY                       TYPE        WAERS_CURC
* | [<-()] MBEW                           TYPE        MBEW
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bapi_mbew_ga_to_mbew.
    "Copied and modified from FM 'MAP2E_MBEW_TO_BAPI_MBEW_GA' - 10.07.2023
    mbew-bwtty = bapi_mbew_ga-val_cat.
    mbew-hkmat = bapi_mbew_ga-orig_mat.
    mbew-zkdat = bapi_mbew_ga-valid_from.
    mbew-mlast = bapi_mbew_ga-ml_settle.
    mbew-mlmaa = bapi_mbew_ga-ml_active.
    mbew-ekalr = bapi_mbew_ga-qty_struct.
    mbew-pdatv = bapi_mbew_ga-fij_pre_cost_est.
    mbew-pdatl = bapi_mbew_ga-fij_cur_cost_est.
    mbew-pdatz = bapi_mbew_ga-fij_fut_cost_est.
    mbew-zpld1 = bapi_mbew_ga-plndprdate1.
    mbew-zpld2 = bapi_mbew_ga-plndprdate2.
    mbew-zpld3 = bapi_mbew_ga-plndprdate3.
    mbew-xlifo = bapi_mbew_ga-lifo_fifo.
    mbew-mypol = bapi_mbew_ga-poolnumber.
    mbew-pprdv = bapi_mbew_ga-per_pre_cost_est.
    mbew-pprdl = bapi_mbew_ga-per_cur_cost_est.
    mbew-abwkz = bapi_mbew_ga-deval_ind.
    mbew-hrkft = bapi_mbew_ga-orig_group.
    mbew-kosgr = bapi_mbew_ga-overhead_grp.
    mbew-pprdz = bapi_mbew_ga-per_fut_cost_est.
    mbew-lfmon = bapi_mbew_ga-curr_period.
    mbew-bwkey = bapi_mbew_ga-val_area.
    mbew-bwtar = bapi_mbew_ga-val_type.
    mbew-pstat = bapi_mbew_ga-maint_stat.
    mbew-lvorm = bapi_mbew_ga-del_flag.
    mbew-vprsv = bapi_mbew_ga-price_ctrl.
    mbew-bwpei = bapi_mbew_ga-tax_cml_un.
    mbew-ownpr = bapi_mbew_ga-in_house.
    mbew-peinh = bapi_mbew_ga-price_unit.
    mbew-bklas = bapi_mbew_ga-val_class.
    mbew-vmvpr = bapi_mbew_ga-pr_ctrl_pp.
    mbew-mtorg = bapi_mbew_ga-mat_origin.
    mbew-mtuse = bapi_mbew_ga-matl_usage.
    mbew-vmpei = bapi_mbew_ga-pr_unit_pp.
    mbew-vmbkl = bapi_mbew_ga-vclass_pp.
    mbew-vjvpr = bapi_mbew_ga-pr_ctrl_py.
    mbew-qklas = bapi_mbew_ga-vm_p_stock.
    mbew-eklas = bapi_mbew_ga-vm_so_stk.
    mbew-vjbkl = bapi_mbew_ga-vclass_py.
    mbew-vjpei = bapi_mbew_ga-pr_unit_py.
    mbew-lfgja = bapi_mbew_ga-fisc_year.

    mbew-vplpr = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-prev_plan_price ) ).
    mbew-lplpr = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-curr_plan_price ) ).
    mbew-verpr = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-moving_pr ) ).
    mbew-stprs = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-std_price ) ).
    mbew-vmver = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-mov_pr_pp ) ).
    mbew-vmstp = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-std_pr_pp ) ).
    mbew-vjver = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-mov_pr_py ) ).
    mbew-vjstp = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-std_pr_py ) ).
    mbew-zkprs = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-future_pr ) ).
    mbew-bwprs = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-taxprice_1 ) ).
    mbew-bwprh = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-commprice1 ) ).
    mbew-vjbws = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-taxprice_3 ) ).
    mbew-vjbwh = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-commprice3 ) ).
    mbew-zplpr = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-plnd_price ) ).
    mbew-zplp1 = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-plndprice1 ) ).
    mbew-zplp2 = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-plndprice2 ) ).
    mbew-zplp3 = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-plndprice3 ) ).
    mbew-bwph1 = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-commprice2 ) ).
    mbew-bwps1 = CONV #( currency_amount_bapi_to_sap( currency = currency bapi_amount = bapi_mbew_ga-taxprice_2 ) ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>BAPI_MFHM_GA_TO_MFHM
* +-------------------------------------------------------------------------------------------------+
* | [--->] BAPI_MFHM_GA                   TYPE        BAPI_MFHM_GA
* | [<-()] MFHM                           TYPE        MFHM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bapi_mfhm_ga_to_mfhm.
    "Copied and modified from FM 'MAP2E_MFHM_TO_BAPI_MFHM_GA' - 10.07.2023
    mfhm-ewform_ref = bapi_mfhm_ga-formula_tot_usage_no_chg.
    mfhm-ewform = bapi_mfhm_ga-formula_tot_usage.
    mfhm-mgform_ref = bapi_mfhm_ga-formula_tot_qty_no_chg.
    mfhm-mgform = bapi_mfhm_ga-formula_tot_qty.
    mfhm-offste_ref = bapi_mfhm_ga-end_offset_no_chg.
    mfhm-offste = bapi_mfhm_ga-end_offset.
    mfhm-bzoffe_ref = bapi_mfhm_ga-end_ref_date_no_chg.
    mfhm-bzoffe = bapi_mfhm_ga-end_ref_date.
    mfhm-offstb_ref = bapi_mfhm_ga-start_offset_no_chg.
    mfhm-offstb = bapi_mfhm_ga-start_offset.
    mfhm-bzoffb_ref = bapi_mfhm_ga-st_ref_date_no_chg.
    mfhm-werks = bapi_mfhm_ga-plant.
    mfhm-kzkbl = bapi_mfhm_ga-create_load_recs.
    mfhm-steuf = bapi_mfhm_ga-ctrl_key.
    mfhm-steuf_ref = bapi_mfhm_ga-ctrl_key_no_chg.
    mfhm-fgru1 = bapi_mfhm_ga-grp_key_1.
    mfhm-fgru2 = bapi_mfhm_ga-grp_key_2.
    mfhm-planv = bapi_mfhm_ga-prt_usage.
    mfhm-ktsch = bapi_mfhm_ga-std_text_key.
    mfhm-ktsch_ref = bapi_mfhm_ga-ref_key_no_chg.
    mfhm-bzoffb = bapi_mfhm_ga-start_ref_date.
    mfhm-ehoffe = bapi_mfhm_ga-end_offset_unit.
    mfhm-ehoffb = bapi_mfhm_ga-start_offset_unit.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>BAPI_MLGN_GA_TO_MLGN
* +-------------------------------------------------------------------------------------------------+
* | [--->] BAPI_MLGN_GA                   TYPE        BAPI_MLGN_GA
* | [<-()] MLGN                           TYPE        MLGN
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bapi_mlgn_ga_to_mlgn.
    "Copied and modified from FM 'MAP2E_MLGN_TO_BAPI_MLGN_GA' - 07.07.2023
    mlgn-l2skr = bapi_mlgn_ga-2step_pick.
    mlgn-vomem = bapi_mlgn_ga-ref_unit.
    mlgn-plkpt = bapi_mlgn_ga-stge_type.
    mlgn-mkapv = bapi_mlgn_ga-capy_usage.
    mlgn-bsskz = bapi_mlgn_ga-spec_mvmt.
    mlgn-kzmbf = bapi_mlgn_ga-msg_to_im.
    mlgn-block = bapi_mlgn_ga-block_stge.
    mlgn-kzzul = bapi_mlgn_ga-add_to_stk.
    mlgn-lety3 = bapi_mlgn_ga-unittype_3.
    mlgn-lety2 = bapi_mlgn_ga-unittype_2.
    mlgn-lety1 = bapi_mlgn_ga-unittype_1.
    mlgn-lgnum = bapi_mlgn_ga-whse_no.
    mlgn-lvorm = bapi_mlgn_ga-del_flag.
    mlgn-lgbkz = bapi_mlgn_ga-stgesector.
    mlgn-ltkze = bapi_mlgn_ga-placement.
    mlgn-ltkza = bapi_mlgn_ga-withdrawal.
    mlgn-lhmg1 = bapi_mlgn_ga-l_equip_1.
    mlgn-lhmg2 = bapi_mlgn_ga-l_equip_2.
    mlgn-lhmg3 = bapi_mlgn_ga-l_equip_3.

    mlgn-lvsme = bapi_mlgn_ga-wm_unit.
    mlgn-bezme = bapi_mlgn_ga-procure_un.
    mlgn-lhme1 = bapi_mlgn_ga-leq_unit_1.
    mlgn-lhme2 = bapi_mlgn_ga-leq_unit_2.
    mlgn-lhme3 = bapi_mlgn_ga-leq_unit_3.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>BAPI_MLGT_GA_TO_MLGT
* +-------------------------------------------------------------------------------------------------+
* | [--->] BAPI_MLGT_GA                   TYPE        BAPI_MLGT_GA
* | [<-()] MLGT                           TYPE        MLGT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bapi_mlgt_ga_to_mlgt.
    "Copied and modified from FM 'MAP2E_MLGT_TO_BAPI_MLGT_GA' - 07.07.2023
    mlgt-lgpla = bapi_mlgt_ga-stge_bin.
    mlgt-kober = bapi_mlgt_ga-pick_area.
    mlgt-lpmin = bapi_mlgt_ga-min_sb_qty.
    mlgt-mamng = bapi_mlgt_ga-ctrl_qty.
    mlgt-lgtyp = bapi_mlgt_ga-stge_type.
    mlgt-lvorm = bapi_mlgt_ga-del_flag.
    mlgt-nsmng = bapi_mlgt_ga-replen_qty.
    mlgt-lgnum = bapi_mlgt_ga-whse_no.
    mlgt-lpmax = bapi_mlgt_ga-max_sb_qty.
    mlgt-rdmng = bapi_mlgt_ga-round_qty.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>BAPI_MPGD_GA_TO_MPGD
* +-------------------------------------------------------------------------------------------------+
* | [--->] BAPI_MPGD_GA                   TYPE        BAPI_MPGD_GA
* | [<-()] MPGD                           TYPE        MPGD
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bapi_mpgd_ga_to_mpgd.
    "Copied and modified from FM 'MAP2E_MPGD_TO_BAPI_MPGD_GA' - 10.07.2023
    mpgd-werks = bapi_mpgd_ga-plant.
    mpgd-prgrp = bapi_mpgd_ga-plng_matl.
    mpgd-prwrk = bapi_mpgd_ga-plng_plant.
    mpgd-umref = bapi_mpgd_ga-convfactor.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>BAPI_MPOP_GA_TO_MPOP
* +-------------------------------------------------------------------------------------------------+
* | [--->] BAPI_MPOP_GA                   TYPE        BAPI_MPOP_GA
* | [<-()] MPOP                           TYPE        MPOP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bapi_mpop_ga_to_mpop.
    "Copied and modified from FM 'MAP2E_MPOP_TO_BAPI_MPOP_GA' - 10.07.2023
    mpop-fimon = bapi_mpop_ga-fixed_pds.
    mpop-gwert = bapi_mpop_ga-basic_value.
    mpop-gwer1 = bapi_mpop_ga-basic_value1.
    mpop-gwer2 = bapi_mpop_ga-basic_value2.
    mpop-vmgwe = bapi_mpop_ga-basic_value_pp.
    mpop-vmgw1 = bapi_mpop_ga-basic_value_pp1.
    mpop-vmgw2 = bapi_mpop_ga-basic_value_pp2.
    mpop-twert = bapi_mpop_ga-trend_value.
    mpop-vmtwe = bapi_mpop_ga-trend_value_pp.
    mpop-prmad = bapi_mpop_ga-mean_absol_dev.
    mpop-vmmad = bapi_mpop_ga-mean_absol_dev_pp.
    mpop-fsumm = bapi_mpop_ga-error_total.
    mpop-vmfsu = bapi_mpop_ga-error_total_pp.
    mpop-gewgr = bapi_mpop_ga-wtg_group.
    mpop-thkof = bapi_mpop_ga-coeff_theil.
    mpop-ausna = bapi_mpop_ga-except_list.
    mpop-proab = bapi_mpop_ga-forec_flow_cont.
    mpop-perkz = bapi_mpop_ga-period_ind.
    mpop-periv = bapi_mpop_ga-fy_variant.
    mpop-werks = bapi_mpop_ga-plant.
    mpop-propr = bapi_mpop_ga-fore_prof.
    mpop-modaw = bapi_mpop_ga-model_si.
    mpop-modav = bapi_mpop_ga-model_sp.
    mpop-kzpar = bapi_mpop_ga-param_opt.
    mpop-opgra = bapi_mpop_ga-optim_lev.
    mpop-kzini = bapi_mpop_ga-initialize.
    mpop-prmod = bapi_mpop_ga-fore_model.
    mpop-alpha = bapi_mpop_ga-alpha_fact.
    mpop-beta1 = bapi_mpop_ga-beta_fact.
    mpop-gamma = bapi_mpop_ga-gamma_fact.
    mpop-delta = bapi_mpop_ga-delta_fact.
    mpop-siggr = bapi_mpop_ga-tracklimit.
    mpop-prdat = bapi_mpop_ga-fore_date.
    mpop-peran = bapi_mpop_ga-hist_vals.
    mpop-perin = bapi_mpop_ga-init_pds.
    mpop-perio = bapi_mpop_ga-season_pds.
    mpop-perex = bapi_mpop_ga-expost_pds.
    mpop-anzpr = bapi_mpop_ga-fore_pds.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>BAPI_MVKE_GA_TO_MVKE
* +-------------------------------------------------------------------------------------------------+
* | [--->] BAPI_MVKE_GA                   TYPE        BAPI_MVKE_GA
* | [<-()] MVKE                           TYPE        MVKE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bapi_mvke_ga_to_mvke.
    "Copied and modified from FM 'MAP2E_MVKE_TO_BAPI_MVKE_GA' - 10.07.2023
    mvke-ktgrm = bapi_mvke_ga-acct_assgt.
    mvke-mvgr1 = bapi_mvke_ga-matl_grp_1.
    mvke-mvgr2 = bapi_mvke_ga-matl_grp_2.
    mvke-mvgr3 = bapi_mvke_ga-matl_grp_3.
    mvke-mvgr4 = bapi_mvke_ga-matl_grp_4.
    mvke-mvgr5 = bapi_mvke_ga-matl_grp_5.
    mvke-prat1 = bapi_mvke_ga-prod_att_1.
    mvke-prat2 = bapi_mvke_ga-prod_att_2.
    mvke-prat3 = bapi_mvke_ga-prod_att_3.
    mvke-prat4 = bapi_mvke_ga-prod_att_4.
    mvke-prat5 = bapi_mvke_ga-prod_att_5.
    mvke-prat6 = bapi_mvke_ga-prod_att_6.
    mvke-prat7 = bapi_mvke_ga-prod_att_7.
    mvke-prat8 = bapi_mvke_ga-prod_att_8.
    mvke-prat9 = bapi_mvke_ga-prod_att_9.
    mvke-prata = bapi_mvke_ga-prod_att10.
    mvke-rdprf = bapi_mvke_ga-round_prof.
    mvke-vavme = bapi_mvke_ga-var_sales_un.
    mvke-megru = bapi_mvke_ga-unit_group.
    mvke-kondm = bapi_mvke_ga-mat_pr_grp.
    mvke-vkorg = bapi_mvke_ga-sales_org.
    mvke-vtweg = bapi_mvke_ga-distr_chan.
    mvke-lvorm = bapi_mvke_ga-del_flag .
    mvke-versg = bapi_mvke_ga-matl_stats.
    mvke-bonus = bapi_mvke_ga-rebate_grp.
    mvke-provg = bapi_mvke_ga-comm_group.
    mvke-sktof = bapi_mvke_ga-cash_disc.
    mvke-vmsta = bapi_mvke_ga-sal_status.
    mvke-vmstd = bapi_mvke_ga-valid_from.
    mvke-aumng = bapi_mvke_ga-min_order.
    mvke-lfmng = bapi_mvke_ga-min_dely .
    mvke-efmng = bapi_mvke_ga-min_mto.
    mvke-scmng = bapi_mvke_ga-dely_unit.
    mvke-mtpos = bapi_mvke_ga-item_cat .
    mvke-dwerk = bapi_mvke_ga-delyg_plnt.
    mvke-prodh = bapi_mvke_ga-prod_hier.
    mvke-pmatn = bapi_mvke_ga-pr_ref_mat.
    mvke-schme = bapi_mvke_ga-dely_uom.
    mvke-vrkme = bapi_mvke_ga-sales_unit.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>BAPI_MYMS_GA_TO_MYMS
* +-------------------------------------------------------------------------------------------------+
* | [--->] BAPI_MYMS_GA                   TYPE        BAPI_MYMS_GA
* | [<-()] MYMS                           TYPE        MYMS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bapi_myms_ga_to_myms.
    "Copied and modified from FM 'MAP2E_MYMS_TO_BAPI_MYMS_GA' - 10.07.2023
    myms-mykey = bapi_myms_ga-lifo_valuation_level.
    myms-mypool = bapi_myms_ga-poolnumber.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_STRUCT_MAPPER=>CURRENCY_AMOUNT_BAPI_TO_SAP
* +-------------------------------------------------------------------------------------------------+
* | [--->] CURRENCY                       TYPE        WAERS_CURC
* | [--->] BAPI_AMOUNT                    TYPE        BAPICURR_D
* | [<-()] SAP_AMOUNT                     TYPE        BAPICURR_D
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD currency_amount_bapi_to_sap.
    CALL FUNCTION 'CURRENCY_AMOUNT_BAPI_TO_SAP'
      EXPORTING
        currency              = currency
        bapi_amount           = bapi_amount
      IMPORTING
        sap_amount            = sap_amount
      EXCEPTIONS
        bapi_amount_incorrect = 1
        OTHERS                = 2.
    IF sy-subrc <> 0.
      MESSAGE |Blad podczas konwersji kwoty BAPI->SAP ( Kod { sy-subrc } )| TYPE 'E'.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_STRUCT_MAPPER=>LANGUAGE_CODE_SAP_TO_ISO
* +-------------------------------------------------------------------------------------------------+
* | [--->] SAP_CODE                       TYPE        T002-SPRAS
* | [<-()] ISO_CODE                       TYPE        T002-LAISO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD language_code_sap_to_iso.
    CALL FUNCTION 'LANGUAGE_CODE_SAP_TO_ISO'
      EXPORTING
        sap_code  = sap_code
      IMPORTING
        iso_code  = iso_code
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
    IF sy-subrc <> 0.
      MESSAGE |Blad podczas konwersji języka SAP->ISO ( Kod { sy-subrc } )| TYPE 'E'.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>MAKT_TO_BAPI_MAKT_GA
* +-------------------------------------------------------------------------------------------------+
* | [--->] MAKT                           TYPE        MAKT
* | [<-()] BAPI_MAKT_GA                   TYPE        BAPI_MAKT_GA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD makt_to_bapi_makt_ga.
    bapi_makt_ga-langu = makt-spras.
    bapi_makt_ga-langu_iso = language_code_sap_to_iso( makt-spras ).
    bapi_makt_ga-matl_desc = makt-maktx.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>MARA_TO_BAPI_MARA_GA
* +-------------------------------------------------------------------------------------------------+
* | [--->] MARA                           TYPE        MARA
* | [<-()] BAPI_MARA_GA                   TYPE        BAPI_MARA_GA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD mara_to_bapi_mara_ga.
    CALL FUNCTION 'MAP2E_MARA_TO_BAPI_MARA_GA'
      EXPORTING
        mara         = mara
      CHANGING
        bapi_mara_ga = bapi_mara_ga.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>MARC_TO_BAPI_MARC_GA
* +-------------------------------------------------------------------------------------------------+
* | [--->] MARC                           TYPE        MARC
* | [<-()] BAPI_MARC_GA                   TYPE        BAPI_MARC_GA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD marc_to_bapi_marc_ga.
    CALL FUNCTION 'MAP2E_MARC_TO_BAPI_MARC_GA'
      EXPORTING
        marc         = marc
      CHANGING
        bapi_marc_ga = bapi_marc_ga.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>MARD_TO_BAPI_MARD_GA
* +-------------------------------------------------------------------------------------------------+
* | [--->] MARD                           TYPE        MARD
* | [<-()] BAPI_MARD_GA                   TYPE        BAPI_MARD_GA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD mard_to_bapi_mard_ga.
    CALL FUNCTION 'MAP2E_MARD_TO_BAPI_MARD_GA'
      EXPORTING
        mard         = mard
      CHANGING
        bapi_mard_ga = bapi_mard_ga.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>MBEW_TO_BAPI_MBEW_GA
* +-------------------------------------------------------------------------------------------------+
* | [--->] MBEW                           TYPE        MBEW
* | [<-()] BAPI_MBEW_GA                   TYPE        BAPI_MBEW_GA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD mbew_to_bapi_mbew_ga.
    CALL FUNCTION 'MAP2E_MBEW_TO_BAPI_MBEW_GA'
      EXPORTING
        mbew         = mbew
      CHANGING
        bapi_mbew_ga = bapi_mbew_ga.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>MFHM_TO_BAPI_MFHM_GA
* +-------------------------------------------------------------------------------------------------+
* | [--->] MFHM                           TYPE        MFHM
* | [<-()] BAPI_MFHM_GA                   TYPE        BAPI_MFHM_GA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD mfhm_to_bapi_mfhm_ga.
    CALL FUNCTION 'MAP2E_MFHM_TO_BAPI_MFHM_GA'
      EXPORTING
        mfhm         = mfhm
      CHANGING
        bapi_mfhm_ga = bapi_mfhm_ga.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>MLGN_TO_BAPI_MLGN_GA
* +-------------------------------------------------------------------------------------------------+
* | [--->] MLGN                           TYPE        MLGN
* | [<-()] BAPI_MLGN_GA                   TYPE        BAPI_MLGN_GA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD mlgn_to_bapi_mlgn_ga.
    CALL FUNCTION 'MAP2E_MLGN_TO_BAPI_MLGN_GA'
      EXPORTING
        mlgn         = mlgn
      CHANGING
        bapi_mlgn_ga = bapi_mlgn_ga.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>MLGT_TO_BAPI_MLGT_GA
* +-------------------------------------------------------------------------------------------------+
* | [--->] MLGT                           TYPE        MLGT
* | [<-()] BAPI_MLGT_GA                   TYPE        BAPI_MLGT_GA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD mlgt_to_bapi_mlgt_ga.
    CALL FUNCTION 'MAP2E_MLGT_TO_BAPI_MLGT_GA'
      EXPORTING
        mlgt         = mlgt
      CHANGING
        bapi_mlgt_ga = bapi_mlgt_ga.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>MPGD_TO_BAPI_MPGD_GA
* +-------------------------------------------------------------------------------------------------+
* | [--->] MPGD                           TYPE        MPGD
* | [<-()] BAPI_MPGD_GA                   TYPE        BAPI_MPGD_GA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD mpgd_to_bapi_mpgd_ga.
    CALL FUNCTION 'MAP2E_MPGD_TO_BAPI_MPGD_GA'
      EXPORTING
        mpgd         = mpgd
      CHANGING
        bapi_mpgd_ga = bapi_mpgd_ga.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>MPOP_TO_BAPI_MPOP_GA
* +-------------------------------------------------------------------------------------------------+
* | [--->] MPOP                           TYPE        MPOP
* | [<-()] BAPI_MPOP_GA                   TYPE        BAPI_MPOP_GA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD mpop_to_bapi_mpop_ga.
    CALL FUNCTION 'MAP2E_MPOP_TO_BAPI_MPOP_GA'
      EXPORTING
        mpop         = mpop
      CHANGING
        bapi_mpop_ga = bapi_mpop_ga.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>MVKE_TO_BAPI_MVKE_GA
* +-------------------------------------------------------------------------------------------------+
* | [--->] MVKE                           TYPE        MVKE
* | [<-()] BAPI_MVKE_GA                   TYPE        BAPI_MVKE_GA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD mvke_to_bapi_mvke_ga.
    CALL FUNCTION 'MAP2E_MVKE_TO_BAPI_MVKE_GA'
      EXPORTING
        mvke         = mvke
      CHANGING
        bapi_mvke_ga = bapi_mvke_ga.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_STRUCT_MAPPER=>MYMS_TO_BAPI_MYMS_GA
* +-------------------------------------------------------------------------------------------------+
* | [--->] MYMS                           TYPE        MYMS
* | [<-()] BAPI_MYMS_GA                   TYPE        BAPI_MYMS_GA
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD myms_to_bapi_myms_ga.
    CALL FUNCTION 'MAP2E_MYMS_TO_BAPI_MYMS_GA'
      EXPORTING
        myms         = myms
      CHANGING
        bapi_myms_ga = bapi_myms_ga.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_STRUCT_MAPPER=>UNIT_OF_MEASURE_ISO_TO_SAP
* +-------------------------------------------------------------------------------------------------+
* | [--->] ISO_CODE                       TYPE        T006-ISOCODE
* | [<-()] SAP_CODE                       TYPE        T006-MSEHI
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD unit_of_measure_iso_to_sap.
    CALL FUNCTION 'UNIT_OF_MEASURE_ISO_TO_SAP'
      EXPORTING
        iso_code  = iso_code                " ISO code for the measurement unit
      IMPORTING
        sap_code  = sap_code               " SAP code for the measurement unit
      EXCEPTIONS
        not_found = 1                " ISO code not found in system
        OTHERS    = 2.
    IF sy-subrc <> 0.
      CLEAR sap_code.
    ENDIF.
  ENDMETHOD.
ENDCLASS.