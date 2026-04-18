package com.webgiadung.webgiadung.dao;

import com.webgiadung.webgiadung.model.InboundDetails;
import java.util.List;

public class InboundDetailsDao extends BaseDao {

    public boolean insert(InboundDetails details) {
        return get().withHandle(handle ->
                handle.createUpdate("""
                    INSERT INTO inbound_details (
                        receipt_code, 
                        supplier_name, 
                        product_id, 
                        pre_stock_qty, 
                        import_qty, 
                        unit_cost, 
                        total_price, 
                        created_at
                    ) 
                    VALUES (
                        :receiptCode, 
                        :supplierName, 
                        :productId, 
                        :preStockQty, 
                        :importQty, 
                        :unitCost, 
                        :totalPrice, 
                        NOW()
                    )
                """)
                        .bindBean(details)
                        .execute() > 0
        );
    }

    public List<InboundDetails> getAllHistory() {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM inbound_details ORDER BY created_at DESC")
                        .mapToBean(InboundDetails.class)
                        .list()
        );
    }
}