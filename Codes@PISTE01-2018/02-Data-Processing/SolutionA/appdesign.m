classdef appdesign < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure matlab.ui.Figure             % UserApp
        UIFigure2 matlab.ui.Figure         % UI Figure
        TabGroup matlab.ui.container.TabGroup % Measurements, Tab 2
        Tab      matlab.ui.container.Tab      % Measurements
        Tab2     matlab.ui.container.Tab      % Tab 2
        Tab3     matlab.ui.container.Tab      % Tab 3
        UIAxes   matlab.ui.control.UIAxes     % Title
        UIAxes2   matlab.ui.control.UIAxes    % Title
        UIAxes3   matlab.ui.control.UIAxes    % Title
        UIAxes4   matlab.ui.control.UIAxes    % Title
        UIAxes5   matlab.ui.control.UIAxes    % Title
        Button   matlab.ui.control.Button % Button
        LabelNumericEditField  matlab.ui.control.Label            % Edit Field
        NumericEditField       matlab.ui.control.NumericEditField % [-Inf Inf]
        LabelNumericEditField2 matlab.ui.control.Label            % Edit Field
        NumericEditField2      matlab.ui.control.NumericEditField % [-Inf Inf]
        LabelNumericEditField3 matlab.ui.control.Label            % Edit Field
        NumericEditField3      matlab.ui.control.NumericEditField % [-Inf Inf]
        LabelTextArea          matlab.ui.control.Label            % Text Area
        TextArea               matlab.ui.control.TextArea         % Drop Down label
        LabelDropDown          matlab.ui.control.Label            % Drop Down
        DropDown               matlab.ui.control.DropDown         % Option ...
        
    end
 
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
        end
        % Button button pushed function
        function IrrigationButtonPushed(app)
            app.UIFigure2 = uifigure;
            app.UIFigure2.Position = [100 100 640 480];
            app.UIFigure2.Name = 'Irrigation';
            setAutoResize(app, app.UIFigure2, true)
            fis=createfis(app);
            rd=reader(app);
            n=size(rd);
            final=[];
            for i=1:n(1)
                final=[final;evalfis([rd(i,1) rd(i,2) rd(i,3)],fis)];
            end
            k = 0:1:n(1)-1;
            app.UIAxes4 = uiaxes(app.UIFigure2);
            plot(app.UIAxes4,k,final(1:n(1),1))
            title(app.UIAxes4, 'Volume for Irrigation');
            xlabel(app.UIAxes4, 'time(hour)');
            ylabel(app.UIAxes4, 'volume(L)');
            app.UIAxes4.Position = [316 156 300 230];
            app.UIAxes5 = uiaxes(app.UIFigure2);
            plot(app.UIAxes5,k,final(1:n(1),2))
            title(app.UIAxes5, 'Duration for Irrigation');
            xlabel(app.UIAxes5, 'time(hour)');
            ylabel(app.UIAxes5, 'duration(minute)');
            app.UIAxes5.Position = [17 156 300 230];
        end
       
            
        
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UserApp';
            setAutoResize(app, app.UIFigure, true)

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Units = 'pixels';
            app.TabGroup.Position = [0 0 640 480];

            % Create Tab
            app.Tab = uitab(app.TabGroup);
            app.Tab.Units = 'pixels';
            app.Tab.Title = 'Humidity';

            % Create UIAxes
            app.UIAxes = uiaxes(app.Tab);
            y=reader(app);
            l=size(y);
            x = 0:1:l(1)-1;
            plot(app.UIAxes,x,y(1:l(1),1))
            title(app.UIAxes, 'Humidity');
            xlabel(app.UIAxes, 'time(hour)');
            ylabel(app.UIAxes, 'humidity(gm water/gm dry air)');
            app.UIAxes.Position = [27 198 399 212];
            
            % Create LabelNumericEditField
            app.LabelNumericEditField = uilabel(app.Tab);
            app.LabelNumericEditField.HorizontalAlignment = 'right';
            app.LabelNumericEditField.Position = [449 330 52 15];
            app.LabelNumericEditField.Text = 'Threshold1';

            % Create NumericEditField
            app.NumericEditField = uieditfield(app.Tab, 'numeric');
            app.NumericEditField.Position = [516 326 100 22];

            % Create LabelNumericEditField2
            app.LabelNumericEditField2 = uilabel(app.Tab);
            app.LabelNumericEditField2.HorizontalAlignment = 'right';
            app.LabelNumericEditField2.Position = [449 286 52 15];
            app.LabelNumericEditField2.Text = 'Threshold2';

            % Create NumericEditField2
            app.NumericEditField2 = uieditfield(app.Tab, 'numeric');
            app.NumericEditField2.Position = [516 282 100 22];

            % Create LabelNumericEditField3
            app.LabelNumericEditField3 = uilabel(app.Tab);
            app.LabelNumericEditField3.HorizontalAlignment = 'right';
            app.LabelNumericEditField3.Position = [449 243 52 15];
            app.LabelNumericEditField3.Text = 'Threshold3';

            % Create NumericEditField3
            app.NumericEditField3 = uieditfield(app.Tab, 'numeric');
            app.NumericEditField3.Position = [516 239 100 22];

             % Create LabelTextArea
            app.LabelTextArea = uilabel(app.Tab);
            app.LabelTextArea.HorizontalAlignment = 'right';
            app.LabelTextArea.Position = [84 117 53 15];
            app.LabelTextArea.Text = 'Description';

            % Create TextArea
            app.TextArea = uitextarea(app.Tab);
            app.TextArea.Position = [152 74 150 60];
            
            % Create Button
            app.Button = uibutton(app.Tab, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @IrrigationButtonPushed);
            app.Button.Position = [481 41 135 34];
            app.Button.Text = 'Synthesis';
            
            % Create Tab2
            app.Tab2 = uitab(app.TabGroup);
            app.Tab2.Units = 'pixels';
            app.Tab2.Title = 'Temperature';
            
            % Create LabelNumericEditField
            app.LabelNumericEditField = uilabel(app.Tab2);
            app.LabelNumericEditField.HorizontalAlignment = 'right';
            app.LabelNumericEditField.Position = [449 330 52 15];
            app.LabelNumericEditField.Text = 'Threshold1';

            % Create NumericEditField
            app.NumericEditField = uieditfield(app.Tab2, 'numeric');
            app.NumericEditField.Position = [516 326 100 22];

            % Create LabelNumericEditField2
            app.LabelNumericEditField2 = uilabel(app.Tab2);
            app.LabelNumericEditField2.HorizontalAlignment = 'right';
            app.LabelNumericEditField2.Position = [449 286 52 15];
            app.LabelNumericEditField2.Text = 'Threshold2';

            % Create NumericEditField2
            app.NumericEditField2 = uieditfield(app.Tab2, 'numeric');
            app.NumericEditField2.Position = [516 282 100 22];

            % Create LabelNumericEditField3
            app.LabelNumericEditField3 = uilabel(app.Tab2);
            app.LabelNumericEditField3.HorizontalAlignment = 'right';
            app.LabelNumericEditField3.Position = [449 243 52 15];
            app.LabelNumericEditField3.Text = 'Threshold3';

            % Create NumericEditField3
            app.NumericEditField3 = uieditfield(app.Tab2, 'numeric');
            app.NumericEditField3.Position = [516 239 100 22];

             % Create LabelTextArea
            app.LabelTextArea = uilabel(app.Tab2);
            app.LabelTextArea.HorizontalAlignment = 'right';
            app.LabelTextArea.Position = [84 117 53 15];
            app.LabelTextArea.Text = 'Description';

            % Create TextArea
            app.TextArea = uitextarea(app.Tab2);
            app.TextArea.Position = [152 74 150 60];
            
            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.Tab2);
            plot(app.UIAxes2,x,y(1:l(1),2))
            title(app.UIAxes2, 'Temperature');
            xlabel(app.UIAxes2, 'time(hour)');
            ylabel(app.UIAxes2, 'temperature(celsius)');
            app.UIAxes2.Position = [27 198 399 212];
          
            % Create Button
            app.Button = uibutton(app.Tab2, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @IrrigationButtonPushed);
            app.Button.Position = [481 41 135 34];
            app.Button.Text = 'Synthesis';
            
             % Create Tab3
            app.Tab3 = uitab(app.TabGroup);
            app.Tab3.Units = 'pixels';
            app.Tab3.Title = 'Radiation';
            
            % Create LabelNumericEditField
            app.LabelNumericEditField = uilabel(app.Tab3);
            app.LabelNumericEditField.HorizontalAlignment = 'right';
            app.LabelNumericEditField.Position = [449 330 52 15];
            app.LabelNumericEditField.Text = 'Threshold1';

            % Create NumericEditField
            app.NumericEditField = uieditfield(app.Tab3, 'numeric');
            app.NumericEditField.Position = [516 326 100 22];

            % Create LabelNumericEditField2
            app.LabelNumericEditField2 = uilabel(app.Tab3);
            app.LabelNumericEditField2.HorizontalAlignment = 'right';
            app.LabelNumericEditField2.Position = [449 286 52 15];
            app.LabelNumericEditField2.Text = 'Threshold2';

            % Create NumericEditField2
            app.NumericEditField2 = uieditfield(app.Tab3, 'numeric');
            app.NumericEditField2.Position = [516 282 100 22];

            % Create LabelNumericEditField3
            app.LabelNumericEditField3 = uilabel(app.Tab3);
            app.LabelNumericEditField3.HorizontalAlignment = 'right';
            app.LabelNumericEditField3.Position = [449 243 52 15];
            app.LabelNumericEditField3.Text = 'Threshold3';

            % Create NumericEditField3
            app.NumericEditField3 = uieditfield(app.Tab3, 'numeric');
            app.NumericEditField3.Position = [516 239 100 22];

             % Create LabelTextArea
            app.LabelTextArea = uilabel(app.Tab3);
            app.LabelTextArea.HorizontalAlignment = 'right';
            app.LabelTextArea.Position = [84 117 53 15];
            app.LabelTextArea.Text = 'Description';

            % Create TextArea
            app.TextArea = uitextarea(app.Tab3);
            app.TextArea.Position = [152 74 150 60];
           
            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.Tab3);
            plot(app.UIAxes3,x,y(1:l(1),3))
            title(app.UIAxes3, 'Solar Radiation');
            xlabel(app.UIAxes3, 'time(hour)');
            ylabel(app.UIAxes3, 'radiation(Mjm-2)');
            app.UIAxes3.Position = [27 198 399 212];
          
            % Create Button
            app.Button = uibutton(app.Tab3, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @IrrigationButtonPushed);
            app.Button.Position = [481 41 135 34];
            app.Button.Text = 'Synthesis';
            
        end
    end

    methods (Access = public)

        % Construct app
        function app = appdesign()

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
        function result = reader(app)
            
            filename=fullfile('./input_data.txt');
            file=fopen(filename,'r');
            u=[];
            v=[];
            w=[];
            while 1
            line = fgetl(file);
            if isfloat(line), break, end
            u=[u;str2double(line(1,1:2))];
            v=[v;str2double(line(1,4:5))];
            w=[w;str2double(line(1,7:8))];
            end
            fclose(file);
            result=[u v w];
        end
        function result=createfis(app)
            fis=newfis('irrigation');
            fis=addvar(fis,'input','humidity',[0 35]);%gm water/gm dry air
            fis=addvar(fis,'input','temperature',[-10 50]);%celsius
            fis=addvar(fis,'input','solar radiation',[5 35]);%Mjm-2
            fis=addmf(fis,'input',1,'wet','zmf',[15 20]);
            fis=addmf(fis,'input',1,'dry','smf',[20 15]);
            fis=addmf(fis,'input',2,'cold','gaussmf',[15 -10]);
            fis=addmf(fis,'input',2,'medium','gaussmf',[15 20]);
            fis=addmf(fis,'input',2,'hot','gaussmf',[15 50]);
            fis=addmf(fis,'input',3,'low','zmf',[17.5 22.5]);
            fis=addmf(fis,'input',3,'intense','smf',[22.5 17.5]);

            fis=addvar(fis,'output','volume',[0 10000]);%in L
            fis=addvar(fis,'output','duration',[0 60]);%in minutes
            fis=addmf(fis,'output',1,'small volume','zmf',[4000 6000]);
            fis=addmf(fis,'output',1,'big volume','smf',[6000 4000]);
            fis=addmf(fis,'output',2,'small period','zmf',[20 40]);
            fis=addmf(fis,'output',2,'long period','smf',[40 60]);
            ruletable=[1 1 0 1 0 1 1;
                       0 1 1 0 1 1 2;
                       0 1 1 1 1 1 1]
            fis=addrule(fis,ruletable);
            result=fis;
        end
    end
end
