package com.portal.gestao_publica.dtos;

import com.portal.gestao_publica.enums.RequestCategoriesEnum;
import com.portal.gestao_publica.models.Address;

public record PostRequestDTO(
        RequestCategoriesEnum category,
        String description,
        String linkedFile,
        Address address,
        Boolean isAnonymous
) {
}