package com.portal.gestao_publica.dtos;

import com.portal.gestao_publica.enums.RequestStatusEnum;

public record PostRequestStatusDTO(
        RequestStatusEnum status,
        String description
) {
}
