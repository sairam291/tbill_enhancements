INSERT INTO tb_mst_process (process_id,created_by,created_date,current_exception_count,is_deleted,oc_status,process_desc,process_name,process_param,process_schedule_time,process_status,product_id)
values (2101, 0,now(),0,false,'O','T Bill auction data process','tbill_auction_data',NULL,NULL,NULL,7);

INSERT INTO tb_mst_process_config (created_by,created_date,is_deleted,key_desc,key_name,key_value,oc_status,updated_by,updated_date,process_id) VALUES
	 (0,now(),false,'auction table name','table_name','tb_tbill_auction_data','O',NULL,NULL,2101),
	 (0,now(),false,'sheet name','sheet_name','Auction WAY','O',NULL,NULL,2101),
	 (0,now(),false,'file convetor','file_convertor','defaultXlsToCsvConvertor','O',NULL,NULL,2101),
	 (0,now(),false,'ccli root location','root_folder_location','D:\3cortex\monitoring_folder\','O',NULL,NULL,2101),
	 (0,now(),false,'File Name','benchmark_file_name','DTB_WORKING_FILE','O',NULL,NULL,2101),
	 (0,now(),false,'file location','location','D:\3cortex\monitoring_folder\FBIL_DEV\inbound\TBill\','O',NULL,NULL,2101),
	 (0,now(),false,'BaseData file location','base_data_location','D:\3cortex\monitoring_folder\FBIL_DEV\inbound\TBill\Basedata\','O',NULL,NULL,2101),
	 (0,now(),false,'outbound location','outbound_location','D:\3cortex\monitoring_folder\fbil\outbound\TBill\','O',NULL,NULL,2101);

INSERT INTO tb_mst_map_headers_columns (created_by,created_date,header_name,is_deleted,mapping_column_name,oc_status,updated_by,updated_date,process_id) VALUES
	 (0,now(),'Date',false,'auction_date','O',NULL,NULL,2101),
	 (0,now(),'Bucket',false,'bucket','O',NULL,NULL,2101),
	 (0,now(),'Tenor',false,'tenor','O',NULL,NULL,2101),
	 (0,now(),'Auction WAY',false,'auction_way','O',NULL,NULL,2101),
	 (0,now(),'Number of Trades Available',false,'no_of_trades','O',NULL,NULL,2101),
	 (0,now(),'Traded WAR',false,'traded_war','O',NULL,NULL,2101),
	 (0,now(),'Average',false,'average','O',NULL,NULL,2101);

-- modifying existing queries
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








