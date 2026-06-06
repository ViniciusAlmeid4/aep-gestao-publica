package com.portal.gestao_publica.dtos;

import com.portal.gestao_publica.enums.RequestStatusEnum;
import com.portal.gestao_publica.models.RequestStatus;

import java.time.LocalDateTime;
import java.util.UUID;

public record RequestStatusResponseDTO(
        Long id,
        RequestStatusEnum status,
        UUID requestId,
        UserResponseDTO responsable,
        String description,
        LocalDateTime createdAt
) {
    public static RequestStatusResponseDTO from(RequestStatus requestStatus) {
        return new RequestStatusResponseDTO(
                requestStatus.getId(),
                requestStatus.getStatus(),
                requestStatus.getRequest().getId(),
                UserResponseDTO.from(requestStatus.getResponsable()),
                requestStatus.getDescription(),
                requestStatus.getCreatedAt()
        );
    }
}
