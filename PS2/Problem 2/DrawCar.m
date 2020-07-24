function [] = DrawCar(xrange,yrange,carloc,s)
Offsetx = 0.05;
Offsety = 0.04;
CarOffsety = 0.08;
clf;
hold on;
x = xrange(1):0.001:xrange(2);
plot(x,sin(s*x),'k', 'LineWidth',2);

Wheel1 = RotateOffset(carloc,[carloc-Offsetx,sin(s*carloc)+Offsety],s);
Wheel2 = RotateOffset(carloc,[carloc+Offsetx,sin(s*carloc)+Offsety],s);
plot(Wheel1(1),Wheel1(2),'o','MarkerSize',8, 'MarkerEdgeColor','k');
plot(Wheel2(1),Wheel2(2),'o','MarkerSize',8, 'MarkerEdgeColor','k');

Box = RotateOffset(carloc,[carloc-2*Offsetx,sin(s*carloc)+CarOffsety;carloc+2*Offsetx,sin(s*carloc)+CarOffsety;carloc-2*Offsetx,sin(s*carloc)+2*CarOffsety;carloc+2*Offsetx,sin(s*carloc)+2*CarOffsety],s);
%keyboard;
plot([Box(1,1) Box(1,2)],[Box(2,1) Box(2,2)],'k');
plot([Box(1,3) Box(1,4)],[Box(2,3) Box(2,4)],'k');
plot([Box(1,1) Box(1,3)],[Box(2,1) Box(2,3)],'k');
plot([Box(1,2) Box(1,4)],[Box(2,2) Box(2,4)],'k');


pbaspect([(xrange(2)-xrange(1)) (yrange(2)-yrange(1)) 1]);
ylim([yrange]);
xlim([xrange(1) xrange(2)]);
set(gca,'XTick',[], 'YTick', []);
hold off;


end