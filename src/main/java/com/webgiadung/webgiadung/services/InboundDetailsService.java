package com.webgiadung.webgiadung.services;

import com.webgiadung.webgiadung.dao.InboundDetailsDao;
import com.webgiadung.webgiadung.model.InboundDetails;

import java.util.List;

public class InboundDetailsService {
     InboundDetailsDao inboundDetailsDao = new InboundDetailsDao();

    public boolean insertInbound(InboundDetails details) {
        if (details.getImportQty() > 0 && details.getUnitCost() > 0) {
            double calculatedTotal = details.getImportQty() * details.getUnitCost();
            details.setTotalPrice(calculatedTotal);
        }

        return inboundDetailsDao.insert(details);
    }

    public List<InboundDetails> getImportHistory() {
        return inboundDetailsDao.getAllHistory();
    }
}

