package com.portal.gestao_publica.services;

import com.portal.gestao_publica.dtos.PostRequestDTO;
import com.portal.gestao_publica.dtos.RequestResponseDTO;
import com.portal.gestao_publica.models.Request;
import com.portal.gestao_publica.models.User;
import com.portal.gestao_publica.repositories.RequestRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.RequestResponseBodyMethodProcessor;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;

@Service
public class RequestService {
    @Autowired
    private RequestRepository requestRepository;

    public Request post(PostRequestDTO dto, User requester) {
        Request request = new Request();
        request.setCategory(dto.category());
        request.setDescription(dto.description());
        request.setLinkedFile(dto.linkedFile());
        request.setAddress(dto.address());
        request.setIsAnonymous(dto.isAnonymous());
        request.setRequester(requester);
        return requestRepository.save(request);
    }

    public Request get(UUID id) {
        return requestRepository.findById(id).orElseThrow();
    }

    public List<Request> getAll() {
        return requestRepository.findAll();
    }

    public List<Request> getAllByRequester(User user) {
        return requestRepository.findAllByRequester(user);
    }

    public Request patch(Request request) {
        return requestRepository.save(request);
    }

    public void delete(UUID id) {
        requestRepository.deleteById(id);
    }
}
