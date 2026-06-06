    @GET
    @Path("/{userId}")
    public ProfileResponse getProfile(@PathParam("userId") UUID userId) {
        User user = requireUser(userId);
        return new ProfileResponse(
            user.id,
            user.email,
            user.nickname,
            avatarUrl(user),
            user.notificationsSnoozedUntil == null ? null : user.notificationsSnoozedUntil.toString(),
            userExecutionModeService.resolve(user).name().toLowerCase(Locale.ROOT)
        );
    }
