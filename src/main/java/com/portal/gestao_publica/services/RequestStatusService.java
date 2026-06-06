package com.portal.gestao_publica.services;

import com.portal.gestao_publica.dtos.PostRequestStatusDTO;
import com.portal.gestao_publica.models.Request;
import com.portal.gestao_publica.models.RequestStatus;
import com.portal.gestao_publica.models.User;
import com.portal.gestao_publica.repositories.RequestRepository;
import com.portal.gestao_publica.repositories.RequestStatusRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class RequestStatusService {
    @Autowired
    private RequestStatusRepository requestStatusRepository;
    @Autowired
    private RequestRepository requestRepository;

    public RequestStatus post(UUID requestId, PostRequestStatusDTO dto, User responsable) {
        Request request = requestRepository.findById(requestId).orElseThrow();

        RequestStatus requestStatus = new RequestStatus();
        requestStatus.setRequest(request);
        requestStatus.setDescription(dto.description());
        requestStatus.setStatus(dto.status());
        requestStatus.setResponsable(responsable);
        return requestStatusRepository.save(requestStatus);
    }

    public RequestStatus get(Long id) {
        return requestStatusRepository.findById(id).orElseThrow();
    }

    public List<RequestStatus> getAllByRequest(UUID requestId) {
        Request request = requestRepository.findById(requestId).orElseThrow();
        return requestStatusRepository.findAllByRequest(request);
    }

    public RequestStatus patch(RequestStatus request) {
        return requestStatusRepository.save(request);
    }

    public void delete(Long id) {
        requestStatusRepository.deleteById(id);
    }
}
