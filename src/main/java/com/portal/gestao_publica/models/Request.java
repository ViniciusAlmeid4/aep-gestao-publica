package com.portal.gestao_publica.models;

import com.portal.gestao_publica.enums.RequestCategoriesEnum;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "requests")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Request {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Enumerated(EnumType.STRING)
    private RequestCategoriesEnum category;

    private String description;

    private String linkedFile;

    @Embedded
    private Address address;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "requester_id")
    private User requester;

    @CreationTimestamp
    private LocalDateTime createdAt;

    private Boolean isAnonymous;

    @OneToMany(mappedBy = "request", cascade = CascadeType.ALL)
    private List<RequestStatus> statuses;
}
