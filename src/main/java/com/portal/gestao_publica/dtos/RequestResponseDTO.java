package com.portal.gestao_publica.dtos;

import com.portal.gestao_publica.enums.RequestCategoriesEnum;
import com.portal.gestao_publica.models.Address;
import com.portal.gestao_publica.models.Request;

import java.time.LocalDateTime;
import java.util.UUID;

public record RequestResponseDTO(
        UUID id,
        RequestCategoriesEnum category,
        String description,
        String linkedFile,
        Address address,
        Boolean isAnonymous,
        LocalDateTime createdAt,
        UserResponseDTO requester,
        RequestStatusResponseDTO lastStatus
) {
    public static RequestResponseDTO from(Request request) {
        return new RequestResponseDTO(
                request.getId(),
                request.getCategory(),
                request.getDescription(),
                request.getLinkedFile(),
                request.getAddress(),
                request.getIsAnonymous(),
                request.getCreatedAt(),
                request.getIsAnonymous() ? null : UserResponseDTO.from(request.getRequester()),
                request.getStatuses() == null ? null : RequestStatusResponseDTO.from(request.getStatuses().getLast())
        );
    }
}