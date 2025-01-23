function plot_re_c()
    rho = 997;
    mu = 0.00089;
    
    U = 0.6 : 0.2 : 2;
    
    TSR = 1 : 8;
    
    Re_c = zeros(1, length(U));

    % rR = 0.7
    % chord length @ r/R = 0.7
    c = 63.85; % [mm]
    
    C = [250 111 90 % 0.6
        201 102 40 % 0.8
        255 157 46 % 1.0
        201 227 32 % 1.2
        9 79 11 % 1.4
        86 143 166 % 1.6
        68 68 158 % 1.8
        218 181 255] / 255; % 2.0

    f = figure(1);
    set(f, 'renderer', 'painter');
    
    for i = 1 : length(U)
        for j = 1 : length(TSR)
            U_rel = U(i) * sqrt(1 + TSR(j)^2 * 0.7^2);
            Re_c(1,j) = (rho * U_rel * (c/1000)) / mu;
        end

        plot(TSR, Re_c, "DisplayName", "U_\infty = " + num2str(U(i)) + ...
            " [ms^{-1}]", "Color", C(i, :), "LineWidth", 1)
        xlabel("\lambda")
        ylabel("Re_c")
        legend("FontSize", 8, "Location", "eastoutside")
        hold on
    end
    
    xlim([1 8])
    
    yline(2*10^5, 'k--', 'Re_c = 200,000', 'LineWidth', 2, "DisplayName", ...
        "IEC Lower Critical Re_c", "LabelHorizontalAlignment", "right", ...
        "LabelVerticalAlignment", "bottom")
    yline(5*10^5, 'r--', 'Re_c = 500,000', 'LineWidth', 2, "DisplayName", ...
        "IEC Upper Critical Re_c", "LabelHorizontalAlignment", "left", ...
        "LabelVerticalAlignment", "bottom")
end
