function [obj1, obj2] = Collision(obj1, obj2)      %obj2 spoczywa
    rel_vel = [obj1.vx-obj2.vx, obj1.vy-obj2.vy];
    center_vector = [obj2.x - obj1.x, obj2.y - obj1.y];         % Wektor łączący środki piłek
    dot_product = dot(rel_vel, center_vector);
    d_norm_sq = dot(center_vector, center_vector);
    v_n = (dot_product/d_norm_sq)*center_vector;             % Rzut wektora prędkości na prostą łączącą środki piłek

    u = obj2.m/obj1.m; % stosunek mas
    obj2_velocity = [obj2.vx obj2.vy];
    %obj1_velocity = [obj1.vx obj1.vy];

    v_s = rel_vel-v_n;    % Rzut wektora prędkości w kierunku prostopadłym do v_n

    new_vel_obj1 = (1-u)/(1+u) * v_n + v_s + obj2_velocity;
    new_vel_obj2 = 2/(1+u) * v_n + obj2_velocity;

    obj1 = obj1.NewVelocity(new_vel_obj1(1), new_vel_obj1(2));
    obj2 = obj2.NewVelocity(new_vel_obj2(1), new_vel_obj2(2));
    
    % Poniższy kod odpowiada za korekte położenia piłek, podczas dużych
    % prędkości piłke przenikają przez siebie i "sklejaja sie" - wynika to
    % z zbyt dużych prędkości w porównaniu do kroku czasowego.
    delta = [obj1.x - obj2.x, obj1.y - obj2.y];
    d = norm(delta);
    overlap = obj1.r + obj2.r - d;

    if overlap > 0
        if d == 0
            direction = [1, 0];
        else
            direction = delta / d;
        end
        correction = 0.5 * overlap * direction;
        obj1 = obj1.NewLocation(obj1.x + correction(1), obj1.y + correction(2));
        obj2 = obj2.NewLocation(obj2.x - correction(1), obj2.y - correction(2));
    end
end