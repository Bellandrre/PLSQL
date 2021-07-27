-- Man! this query kinda crazy. 
-- Here we are trying to delete from one transaction table for matching rows in an interface table. But the catch, No combination of columns in a single row of the interface table make a unique key.
-- The rows can have duplicate data.
-- So we group these duplicates in the interface table and obtain their ROWIDs(Oracle provides and internal id for each row in its table other than the constraints the table has)
-- Delete the same row id from the transaction table.

 DELETE FROM SOME_SHIPMENT_TABLE WHERE ROWID IN(
    WITH PB_TEMP AS ( SELECT COUNT(*) count_rows, PLPT_INT.HEAD_ID, PAIP.LINE_NUMBER, PLPT_INT.REQUEST_ID, PLPT_INT.BATCH_ID,
                      PLPT_INT.SHIP_ORG_ID,PLPT_INT.SHIP_TO_LOCATION_ID, PLPT_INT.QUANTITY, PLPT_INT.TARGET_PRICE, PLPT_INT.EFFECTIVE_START_DATE, PLPT_INT.EFFECTIVE_END_DATE
                      FROM
                      PON_LINE_PRICE_TIERS_INT PLPT_INT,
                      PON_AUCTION_ITEM_PRICES PAIP
                      WHERE  PLPT_INT.HEAD_ID = p_HEAD_ID
                      AND PLPT_INT.REQUEST_ID = p_request_id
                      AND PLPT_INT.IMPORT_ACTION = PON_GLOBAL_CONSTANTS.G_DELETE_ACTION
                      AND PLPT_INT.IMPORT_STATUS = PON_GLOBAL_CONSTANTS.G_PROCESSED_STATUS
                      AND PLPT_INT.SHIPMENT_TYPE = PON_GLOBAL_CONSTANTS.G_PRICE_TIER_TYPE_PB
                      AND PLPT_INT.HEAD_ID = PAIP.HEAD_ID
                      AND PLPT_INT.DOCUMENT_DISP_LINE_NUMBER = PAIP.DOCUMENT_DISP_LINE_NUMBER
                      GROUP BY (PLPT_INT.HEAD_ID, PAIP.LINE_NUMBER, PLPT_INT.REQUEST_ID, PLPT_INT.BATCH_ID,
                                PLPT_INT.DOCUMENT_DISP_LINE_NUMBER,
                                PLPT_INT.SHIP_ORG_ID, 
                                PLPT_INT.SHIP_TO_LOCATION_ID,
                                PLPT_INT.TARGET_PRICE,
                                PLPT_INT.QUANTITY,
                                PLPT_INT.EFFECTIVE_START_DATE, 
                                PLPT_INT.EFFECTIVE_END_DATE) ORDER BY PAIP.LINE_NUMBER )
            SELECT PBTX.rid from (
                      SELECT PAS.ROWID rid,
                             PAS.HEAD_ID,
                             PAIP.LINE_NUMBER,
                             PLPT_INT.REQUEST_ID,
                             PLPT_INT.BATCH_ID,
                             PAS.SHIP_ORG_ID,
                             PAS.SHIP_TO_LOCATION_ID,
                             PAS.QUANTITY, 
                             PAS.PRICE, 
                             PAS.EFFECTIVE_START_DATE, 
                             PAS.EFFECTIVE_END_DATE,
                             ROW_NUMBER() over (PARTITION BY PAS.HEAD_ID,
                                                             PAS.LINE_NUMBER,
                                                             PAS.SHIP_ORG_ID,
                                                             PAS.SHIP_TO_LOCATION_ID,
                                                             PAS.QUANTITY,
                                                             PAS.PRICE,
                                                             PAS.EFFECTIVE_START_DATE,
                                                             PAS.EFFECTIVE_END_DATE ORDER BY  PAIP.LINE_NUMBER) row_num
                     FROM
                            PON_LINE_PRICE_TIERS_INT PLPT_INT,
                            PON_AUCTION_ITEM_PRICES PAIP,
                            PON_AUCTION_SHIPMENTS_ALL PAS
                WHERE
                  PLPT_INT.HEAD_ID = p_HEAD_ID
                  AND PLPT_INT.REQUEST_ID = p_request_id
                  AND PLPT_INT.IMPORT_ACTION = PON_GLOBAL_CONSTANTS.G_DELETE_ACTION
                  AND PLPT_INT.IMPORT_STATUS = PON_GLOBAL_CONSTANTS.G_PROCESSED_STATUS
                  AND PLPT_INT.SHIPMENT_TYPE = PON_GLOBAL_CONSTANTS.G_PRICE_TIER_TYPE_PB
                  AND PLPT_INT.HEAD_ID = PAIP.HEAD_ID
                  AND PLPT_INT.DOCUMENT_DISP_LINE_NUMBER = PAIP.DOCUMENT_DISP_LINE_NUMBER
                  AND PAS.HEAD_ID = PAIP.HEAD_ID
                  AND PAS.LINE_NUMBER = PAIP.LINE_NUMBER
                  AND NVL(PLPT_INT.SHIP_ORG_ID, -1) = NVL(PAS.SHIP_ORG_ID, -1)
                  AND NVL(PLPT_INT.SHIP_TO_LOCATION_ID, -1) =  NVL(PAS.SHIP_TO_LOCATION_ID, -1)
                  AND NVL(PLPT_INT.TARGET_PRICE, -1) =  NVL(PAS.PRICE, -1)
                  AND NVL(PLPT_INT.QUANTITY, -1) =  NVL(PAS.QUANTITY, -1)
                  AND DECODE(PLPT_INT.EFFECTIVE_START_DATE, PAS.EFFECTIVE_START_DATE, 1, 0) = 1
                  AND DECODE(PLPT_INT.EFFECTIVE_END_DATE, PAS.EFFECTIVE_END_DATE, 1, 0) = 1) PBTX, PB_TEMP PBTMP
            WHERE PBTMP.HEAD_ID = PBTX.HEAD_ID
                  AND PBTMP.REQUEST_ID = PBTX.REQUEST_ID
                  AND PBTMP.BATCH_ID = PBTX.BATCH_ID
                  AND NVL(PBTX.SHIP_ORG_ID, -1) =  NVL(PBTMP.SHIP_ORG_ID, -1) 
                  AND NVL(PBTX.SHIP_TO_LOCATION_ID, -1) =  NVL(PBTMP.SHIP_TO_LOCATION_ID, -1) 
                  AND NVL(PBTX.PRICE, -1) = NVL(PBTMP.TARGET_PRICE, -1)
                  AND NVL(PBTX.QUANTITY, -1) = NVL(PBTMP.QUANTITY, -1)
                  AND DECODE(PBTX.EFFECTIVE_START_DATE, PBTMP.EFFECTIVE_START_DATE, 1, 0) = 1
                  AND DECODE(PBTX.EFFECTIVE_END_DATE, PBTMP.EFFECTIVE_END_DATE, 1, 0) = 1
                  AND PBTX.row_num <= PBTMP.count_rows);
