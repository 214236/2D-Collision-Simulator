classdef ball
    properties
        x   % współrzędna x
        y   % współrzędna y
        vx  % składowa prędkości x
        vy  % składowa prędkości y
        m   % masa piłki
        r   % promień piłki
    end

    methods
        function obj = ball(x, y, vx, vy, m, r)
            if nargin > 0
                obj.x = x;
                obj.y = y;
                obj.vx = vx;
                obj.vy = vy;
                obj.m = m;
                obj.r = r;
            end
        end

        function obj = NewVelocity(obj, new_vx, new_vy)
            obj.vx = new_vx;
            obj.vy = new_vy;
        end

        function obj = NewLocation(obj, new_x, new_y)
            obj.x = new_x;
            obj.y = new_y;
        end

        function obj = Show(obj, ax)
            theta = linspace(0, 2*pi, 360);
            x_plot = obj.r*cos(theta) + obj.x;
            y_plot = obj.r*sin(theta) + obj.y;
            fill(ax, x_plot, y_plot, 'r');

            %text(obj.x, obj.y, sprintf("%.2f kg", obj.m), "HorizontalAlignment", "center");
        end

        function obj = BorderCollision(obj, ax)
            right   = ax(2) - obj.r;
            left    = ax(1) + obj.r;
            up      = ax(4) - obj.r;
            down    = ax(3) + obj.r;
            s_err = 1e-4;
            
            if obj.x >= right
                obj.vx = -obj.vx;
                obj.x = right - s_err;
            end
            if obj.x <= left
                obj.vx = -obj.vx;
                obj.x = left + s_err;
            end
            if obj.y >= up
                obj.vy = -obj.vy;
                obj.y = up - s_err;
            end
            if obj.y <= down
                obj.vy = -obj.vy;
                obj.y = down + s_err;
            end
        end


        function dist = Distance(obj, other_obj)    % Odległość od środka do środka
            dist = sqrt((obj.x-other_obj.x)^2+(obj.y-other_obj.y)^2);
        end

        function result = IfCollision(obj, other_obj)
            A = -(obj.vy-other_obj.vy);     %Współrzędna y prędkości względnej dla ciała obj względem other_obj
            B = obj.vx - other_obj.vx;      %Współrzędna x -||-
            % Zderzenie nastąpi gdy suma promieni ciał jest większa od odległości środka ciała spoczywającego do przedłużenie wektora prędkości
            result = ((obj.r+other_obj.r)*sqrt(A^2+B^2) > abs(A*other_obj.x + B*other_obj.y));
        end

    end
end