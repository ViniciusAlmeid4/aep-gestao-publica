package com.portal.gestao_publica.controllers;

import com.portal.gestao_publica.dtos.PostRequestDTO;
import com.portal.gestao_publica.dtos.PostRequestStatusDTO;
import com.portal.gestao_publica.dtos.RequestResponseDTO;
import com.portal.gestao_publica.dtos.RequestStatusResponseDTO;
import com.portal.gestao_publica.enums.RolesEnum;
import com.portal.gestao_publica.models.Request;
import com.portal.gestao_publica.models.RequestStatus;
import com.portal.gestao_publica.models.User;
import com.portal.gestao_publica.services.RequestService;
import com.portal.gestao_publica.services.RequestStatusService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/requests")
public class RequestController {
    @Autowired
    private RequestService requestService;
    @Autowired
    private RequestStatusService requestStatusService;

    @GetMapping(path = "")
    public ResponseEntity<List<RequestResponseDTO>> getAll(@AuthenticationPrincipal User user) {
        if (user.getRole().equals(RolesEnum.FUNCIONARIO_PREFEITURA)){
            return ResponseEntity.ok().body(requestService.getAll().stream().map(RequestResponseDTO::from).toList());
        } else {
            return ResponseEntity.ok().body(requestService.getAllByRequester(user).stream().map(RequestResponseDTO::from).toList());
        }
    }

    @PostMapping(path = "")
    public ResponseEntity<RequestResponseDTO> post(@RequestBody PostRequestDTO request, @AuthenticationPrincipal User user) {
        Request created = requestService.post(request, user);
        URI uri = ServletUriComponentsBuilder.fromCurrentRequest().path("/{id}").buildAndExpand(created.getId()).toUri();
        return ResponseEntity.created(uri).body(RequestResponseDTO.from(created));
    }

    @GetMapping(path = "/{id}/status")
    public ResponseEntity<List<RequestStatusResponseDTO>> getAllStatus(@PathVariable UUID id) {
        return ResponseEntity.ok().body(
                requestStatusService.getAllByRequest(id)
                        .stream()
                        .map(RequestStatusResponseDTO::from)
                        .toList()
        );
    }

    @PostMapping(path = "/{id}/status")
    public ResponseEntity<RequestStatusResponseDTO> postStatus(@PathVariable UUID id, @RequestBody PostRequestStatusDTO requestStatus, @AuthenticationPrincipal User user) {
        RequestStatus created = requestStatusService.post(id, requestStatus, user);
        URI uri = ServletUriComponentsBuilder.fromCurrentRequest().path("/{id}").buildAndExpand(created.getId()).toUri();
        return ResponseEntity.created(uri).body(RequestStatusResponseDTO.from(created));
    }
}
