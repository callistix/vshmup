-- improvements:
--  - enemies shoot at player (in progress)
--  - enemy waves (pre-programming enemy movements)
--  - player has 3 lives

GAME_STATE_RUN = 0
GAME_STATE_KILLED = 1

function love.load()
    math.randomseed(os.time())

    spritesheet = love.graphics.newImage("png/spritesheet.png")
    quad_player = love.graphics.newQuad(0, 0, 32, 32, spritesheet)
    quad_enemy = love.graphics.newQuad(32, 0, 32, 32, spritesheet)
    quad_player_shot = love.graphics.newQuad(64, 0, 4, 4, spritesheet)
    quad_enemy_shot = love.graphics.newQuad(96, 0, 4, 4, spritesheet)

    player = {}
    player.x = 400
    player.y = 500
    player.shoot = false
    player.shots = {}
    player.shoot_t = 0

    enemies = {}
    enemies.next_max = 500
    enemies.next_t = math.random(enemies.next_max)
    enemies.list = {}

    game_state = GAME_STATE_RUN

end

function love.update(dt)
    if game_state == GAME_STATE_RUN then
        if love.keyboard.isDown("left") then
            player.x = player.x - 4

            if player.x < 10 then player.x = 10 end
        end
        if love.keyboard.isDown("right") then
            player.x = player.x + 4
            if player.x > 758 then player.x = 758 end
        end

        if love.keyboard.isDown("space") then
            player.shoot = true
            player_shoot()
        else
            player.shoot = false
            player.shoot_t = 0
        end

        detect_collisions()

        player_shots_update()

        enemies_update()
    end
end

function love.draw()
    if game_state == GAME_STATE_RUN then
        love.graphics.draw(spritesheet, quad_player, player.x, player.y)

        for shot in pairs(player.shots) do
            love.graphics.draw(spritesheet, quad_player_shot, player.shots[shot].x, player.shots[shot].y)
        end

        for enemy in pairs(enemies.list) do
            love.graphics.draw(spritesheet, quad_enemy, enemies.list[enemy].x, enemies.list[enemy].y)
        end
    elseif game_state == GAME_STATE_KILLED then
        love.graphics.print("GAME OVER", 380, 300)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function player_shoot()
    if player.shoot_t == 0 then
        table.insert(player.shots, { x = player.x + 14, y = player.y })
    end

    player.shoot_t = player.shoot_t + 1
    if player.shoot_t > 20 then
        player.shoot_t = 0
    end
end

function detect_collisions()

    -- detect shots / enemy collisions
    for shot in pairs(player.shots) do
        shot_x = player.shots[shot].x
        shot_y = player.shots[shot].y

        for enemy in pairs(enemies.list) do
            enemy_x = enemies.list[enemy].x
            enemy_y = enemies.list[enemy].y

            if shot_x + 4 > enemy_x and
               shot_y + 4 > enemy_y and
               shot_x < enemy_x + 32 and
               shot_y < enemy_y + 32 then
                table.remove(player.shots, shot)
                table.remove(enemies.list, enemy)
                break
            end
        end
    end

    -- detect enemy / player collisions
    for enemy in pairs(enemies.list) do
        enemy_x = enemies.list[enemy].x
        enemy_y = enemies.list[enemy].y

        if enemy_x + 32 > player.x and
           enemy_y + 32 > player.y and
           enemy_x < player.x + 32 and
           enemy_y < player.y + 32 then
            table.remove(enemies.list, enemy)
            game_state = GAME_STATE_KILLED
        end
    end
end

function player_shots_update()
    for shot in pairs(player.shots) do
        player.shots[shot].y = player.shots[shot].y - 4

        if player.shots[shot].y < 0 then
            table.remove(player.shots, shot)
        end
    end
end

function enemies_update()
    enemies.next_t = enemies.next_t - 1

    for enemy in pairs(enemies.list) do
        enemies.list[enemy].y = enemies.list[enemy].y + 1
        enemies.list[enemy].shoot_t = enemies.list[enemy].shoot_t - 1

        -- update enemy shots
        for shot in pairs(enemies.list[enemy].shots) do
            -- TODO
        end

        if enemies.list[enemy].y > 632 then
            table.remove(enemies.list, enemy)
        else
            if enemies.list[enemy].shoot_t <= 0 then

                shot = {
                    x = enemies.list[enemy].x,
                    y = enemies.list[enemy].y,
                    v = 5,
                    dir = { x = player.x + 16, y = player.y + 16 }
                }

                table.insert(enemies.list[enemy].shots, shot)

                enemies.list[enemy].shoot_t = math.random(100)
            end
        end
    end

    if enemies.next_t <= 0 then
        table.insert(enemies.list, { x = 10 + math.random(758), y = -32, shoot_t = math.random(100), shots = {}})
        enemies.next_t = math.random(enemies.next_max)
    end
end
