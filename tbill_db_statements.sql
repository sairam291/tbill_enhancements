INSERT INTO tb_mst_process (process_id,created_by,created_date,current_exception_count,is_deleted,oc_status,process_desc,process_name,process_param,process_schedule_time,process_status,product_id)
values (2101, 0,now(),0,false,'O','T Bill auction data process','tbill_auction_data',NULL,NULL,NULL,7);

INSERT INTO tb_mst_process_config (created_by,created_date,is_deleted,key_desc,key_name,key_value,oc_status,updated_by,updated_date,process_id) VALUES
	 (0,now(),false,'auction table name','table_name','tb_tbill_auction_data','O',NULL,NULL,2101),
	 (0,now(),false,'sheet name','sheet_name','Auction WAY','O',NULL,NULL,2101),
	 (0,now(),false,'file convetor','file_convertor','defaultXlsToCsvConvertor','O',NULL,NULL,2101),
	 (0,now(),false,'ccli root location','root_folder_location','/apps/fbil/wasdm/ccilinbound/','O',NULL,NULL,2101),
	 (0,now(),false,'File Name','benchmark_file_name','DTB_WORKING_FILE','O',NULL,NULL,2101),
	 (0,now(),false,'file location','location','/FBIL_DEV/inbound/TBill/','O',NULL,NULL,2101),
	 (0,now(),false,'BaseData file location','base_data_location','/FBIL_DEV/inbound/TBill/Basedata/','O',NULL,NULL,2101),
	 (0,now(),false,'outbound location','outbound_location','/fbil/outbound/TBill/','O',NULL,NULL,2101);

INSERT INTO tb_mst_map_headers_columns (created_by,created_date,header_name,is_deleted,mapping_column_name,oc_status,updated_by,updated_date,process_id) VALUES
	 (0,now(),'Date',false,'auction_date','O',NULL,NULL,2101),
	 (0,now(),'Bucket',false,'bucket','O',NULL,NULL,2101),
	 (0,now(),'Tenor',false,'tenor','O',NULL,NULL,2101),
	 (0,now(),'Auction WAY',false,'auction_way','O',NULL,NULL,2101),
	 (0,now(),'Number of Trades Available',false,'no_of_trades','O',NULL,NULL,2101),
	 (0,now(),'Traded WAR',false,'traded_war','O',NULL,NULL,2101),
	 (0,now(),'Average',false,'average','O',NULL,NULL,2101);

--------- modifying existing queries-------------------------------------------------
update tb_mst_query_store 
set identifier = concat(identifier, '_OLD'),
oc_status = 'C',
updated_date = now()
where identifier = 'T-BILL_UPDWORKING' ;

update  tb_mst_query_store 
set identifier = concat(identifier, '_OLD'),
oc_status = 'C',
updated_date = now()
where identifier = 'T-BILL_FETCHWORKING' ;

update tb_mst_query_store 
set identifier = concat(identifier, '_OLD'),
oc_status = 'C',
updated_date = now()
where identifier = 'T-BILL_FETCHAUGMENTEDDATA' ;

INSERT INTO tb_mst_query_store (created_by,created_date,description,identifier,is_deleted,oc_status,query) VALUES
	 (99,now(),'updates working column in the trade dump for a given date','T-BILL_UPDWORKING',false,'O','UPDATE tb_tbill_trade_data SET working_data = TRUE, updated_by = :updateBy, updated_date = :updatedDate WHERE trade_date = :processDate  and deal_quantity >= :tradeSize and new_tenor = :newTenor and processed = FALSE AND is_deleted = false'),
	 (99,now(),'Returns the working trade dump for a given date','T-BILL_FETCHWORKING',false,'O','SELECT data_id AS "dataId", created_by AS "createdBy", created_date AS "createdDate", arcdint AS "arcdint", buy_broker_id AS "buyBrokerId", buyer_constituent_name AS "buyerConstituentName", buyer_mem_id AS "buyerMemId", buyer_member AS "buyerMember", coupon AS "coupon", deal_id AS "dealId", deal_price AS "dealPrice", deal_quantity AS "dealQuantity", grs_consideration AS "grsConsideration", is_deleted AS "isDeleted", isin_desc AS "isinDesc", isin_no AS "isinNo", maturity_date AS "maturityDate", outlier AS "outlier", processed AS "processed", residual_tenor AS "residualTenor", sell_broker_id AS "sellBrokerId", seller_constituent_name AS "sellerConstituentName", seller_mem_id AS "sellerMemId", seller_member AS "sellerMember", settlement_date AS "settlementDate", trade_date AS "tradeDate", trade_source AS "tradeSource", updated_by AS "updatedBy", updated_date AS "updatedDate", working_data AS "workingData", yield AS "yield", new_tenor AS "newTenor" FROM tb_tbill_trade_data WHERE trade_date = :processDate AND deal_quantity >= :tradeSize AND new_tenor = :newTenor AND processed = false AND is_deleted = false'),
	 (99,now(),'fetch MOT data to augment','T-BILL_FETCHAUGMENTEDDATA',false,'O','SELECT data_id AS "dataId", bucket AS "bucket", buy_count AS "buyCount", buy_order_amount AS "buyOrderAmount", buy_price AS "buyPrice", final_amount AS "finalAmount", final_count AS "finalCount", instrument_identity AS "instrumentIdentity", isin_no AS "isinNo", maturity_date AS "maturityDate", mid_quote AS "midQuote", sell_count AS "sellCount", sell_order_amount AS "sellOrderAmount", sell_price AS "sellPrice", settlement_date AS "settlementDate", spread_bps AS "spreadBps", created_by AS "createdBy", created_date AS "createdDate", is_deleted AS "isDeleted", outlier AS "outlier", processed AS "processed", updated_by AS "updatedBy", updated_date AS "updatedDate", working_data AS "workingData", residual_maturity AS "residualMaturity", new_tenor AS "newTenor" FROM tb_tbill_bothsides_order_data WHERE final_amount >= :orderSize AND settlement_date = :settlementDate AND new_tenor = :newTenor AND spread_bps <= :minBasisPoints AND processed = false AND is_deleted = false'),
	 (99,now(),'update processed column to true in auction table','T-BILL_AUCTION_UPDPROCESSEDDATA',false,'O','UPDATE tb_tbill_auction_data SET processed = true, updated_by = :updateBy, updated_date = :updatedDate WHERE auction_date = :processDate AND processed = false AND is_deleted = false'),
	 (99,now(),'update outlier second stage column to true in trade data table','T-BILL_OUTLIER_SS_UPDOUTLIERSBYDATAID',false,'O','UPDATE tb_tbill_trade_data SET outlier_ss = true, updated_by = :updateBy, updated_date = :updatedDate WHERE data_id = :dataId AND processed = false AND is_deleted = false');



---------- update tb_tbill_tenors ------------------------------------------------------
update tb_tbill_tenors 
set standard_tenor = true;


update tb_tbill_tenors set residual_maturity_start_days = 1, residual_maturity_end_days = 7, updated_date=now() where tenor_name='7 Days';
update tb_tbill_tenors set residual_maturity_start_days = 8, residual_maturity_end_days = 15, updated_date=now() where tenor_name='14 Days';
update tb_tbill_tenors set residual_maturity_start_days = 16, residual_maturity_end_days = 45, updated_date=now() where tenor_name='1 Month';
update tb_tbill_tenors set residual_maturity_start_days = 46, residual_maturity_end_days = 75, updated_date=now() where tenor_name='2 Months';
update tb_tbill_tenors set residual_maturity_start_days = 76, residual_maturity_end_days = 105, updated_date=now() where tenor_name='3 Months';
update tb_tbill_tenors set residual_maturity_start_days = 106, residual_maturity_end_days = 135, updated_date=now() where tenor_name='4 Months';
update tb_tbill_tenors set residual_maturity_start_days = 136, residual_maturity_end_days = 165, updated_date=now() where tenor_name='5 Months';
update tb_tbill_tenors set residual_maturity_start_days = 166, residual_maturity_end_days = 195, updated_date=now() where tenor_name='6 Months';
update tb_tbill_tenors set residual_maturity_start_days = 196, residual_maturity_end_days = 225, updated_date=now() where tenor_name='7 Months';
update tb_tbill_tenors set residual_maturity_start_days = 226, residual_maturity_end_days = 255, updated_date=now() where tenor_name='8 Months';
update tb_tbill_tenors set residual_maturity_start_days = 256, residual_maturity_end_days = 285, updated_date=now() where tenor_name='9 Months';
update tb_tbill_tenors set residual_maturity_start_days = 286, residual_maturity_end_days = 315, updated_date=now() where tenor_name='10 Months';
update tb_tbill_tenors set residual_maturity_start_days = 316, residual_maturity_end_days = 345, updated_date=now() where tenor_name='11 Months';
update tb_tbill_tenors set residual_maturity_start_days = 346, residual_maturity_end_days = 1000000, updated_date=now() where tenor_name='12 Months';






