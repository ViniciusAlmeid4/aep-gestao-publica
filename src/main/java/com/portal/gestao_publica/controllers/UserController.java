package com.portal.gestao_publica.controllers;

import com.portal.gestao_publica.dtos.PostUserRequestDTO;
import com.portal.gestao_publica.models.User;
import com.portal.gestao_publica.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/users")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping("")
    public ResponseEntity<List<User>> getAll() {
        return ResponseEntity.ok().body(userService.getAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> get(@PathVariable UUID id) {
        return ResponseEntity.ok().body(userService.get(id));
    }

    @PostMapping("")
    public ResponseEntity<User> post(@RequestBody PostUserRequestDTO postUser) {
        User user = userService.post(postUser);
        URI uri = ServletUriComponentsBuilder.fromCurrentRequest().path("{id}").buildAndExpand(user.getId()).toUri();
        return ResponseEntity.created(uri).body(user);
    }

    @PatchMapping("/{id}")
    public ResponseEntity<Void> patch(@PathVariable UUID id, @RequestBody PostUserRequestDTO patchUser) {
        userService.patch(patchUser, id);
        return ResponseEntity.noContent().build();
    }
}
