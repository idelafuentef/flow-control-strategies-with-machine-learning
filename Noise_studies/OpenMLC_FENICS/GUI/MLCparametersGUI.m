function mlcParameters=MLCparametersGUI(mlcParameters)
    
    if nargin<1
        mlcParameters=MLCparameters;
    end
    
    NumberOfTabs = 6;               % Number of tabs to be generated
        TabLabels = {'Open Image File'; 'Image'; 'Tab3'; 'Tab4'; 'Tab 5'; 'Tab 6'};
        if size(TabLabels,1) ~= NumberOfTabs
            errordlg('Number of tabs and tab labels must be the same','Setup Error');
            return
        end
    
        %   Set Number of tabs and tab labels.  Make sure the number of tab labels
%   match the HumberOfTabs setting.
        NumberOfTabs = 5;               % Number of tabs to be generated
        TabLabels = {'Problem setup'; 'Individuals setup'; 'Regression setup'; 'Evaluation setup'; 'MLC options'};
        if size(TabLabels,1) ~= NumberOfTabs
            errordlg('Number of tabs and tab labels must be the same','Setup Error');
            return
        end
        
%   Get user screen size
        SC = get(0, 'ScreenSize');
        MaxMonitorX = SC(3);
        MaxMonitorY = SC(4);
        
 %   Set the figure window size values
        MainFigScale = 1;          % Change this value to adjust the figure size
        MaxWindowX = round(MaxMonitorX*MainFigScale);
        MaxWindowY = round(MaxMonitorY*MainFigScale);
        XBorder = (MaxMonitorX-MaxWindowX)/2;
        YBorder = (MaxMonitorY-MaxWindowY)/2; 
        TabOffset = 0;              % This value offsets the tabs inside the figure.
        ButtonHeight = 40;
        PanelWidth = MaxWindowX-2*TabOffset+4;
        PanelHeight = MaxWindowY-ButtonHeight-2*TabOffset;
        ButtonWidth = round((PanelWidth-NumberOfTabs)/NumberOfTabs);
                
 %   Set the color varables.  
        White = [1  1  1];            % White - Selected tab color     
        BGColor = .9*White;           % Light Grey - Background color

%%   Create a figure for the tabs
    hTabFig = figure(...
            'Units', 'pixels',...
            'Toolbar', 'none',...
            'Position',[ XBorder, YBorder, MaxWindowX, MaxWindowY ],...
            'NumberTitle', 'off',...
            'Name', 'MLCparametersGUI',...
            'MenuBar', 'none',...
            'Resize', 'off',...
            'DockControls', 'off',...
            'Color', White);
        
  %%   Define a cell array for panel and pushbutton handles, pushbuttons labels and other data
    %   rows are for each tab + two additional rows for other data
    %   columns are uipanel handles, selection pushbutton handles, and tab label strings - 3 columns.
            TabHandles = cell(NumberOfTabs,3);
            TabHandles(:,3) = TabLabels(:,1);
    %   Add additional rows for other data
            TabHandles{NumberOfTabs+1,1} = hTabFig;         % Main figure handle
            TabHandles{NumberOfTabs+1,2} = PanelWidth;      % Width of tab panel
            TabHandles{NumberOfTabs+1,3} = PanelHeight;     % Height of tab panel
            TabHandles{NumberOfTabs+2,1} = 0;               % Handle to default tab 2 content(set later)
            TabHandles{NumberOfTabs+2,2} = White;           % Selected tab Color
            TabHandles{NumberOfTabs+2,3} = BGColor;         % Background color
            
%%   Build the Tabs
        for TabNumber = 1:NumberOfTabs
        % create a UIPanel   
            TabHandles{TabNumber,1} = uipanel('Units', 'pixels', ...
                'Visible', 'off', ...
                'Backgroundcolor', White, ...
                'BorderWidth',1, ...
                'Position', [TabOffset TabOffset ...
                PanelWidth PanelHeight]);

        % create a selection pushbutton
            TabHandles{TabNumber,2} = uicontrol('Style', 'pushbutton',...
                'Units', 'pixels', ...
                'BackgroundColor', BGColor, ...
                'Position', [TabOffset+(TabNumber-1)*ButtonWidth PanelHeight+TabOffset...
                    ButtonWidth ButtonHeight], ...          
                'String', TabHandles{TabNumber,3},...
                'HorizontalAlignment', 'center',...
                'FontName', 'arial',...
                'FontWeight', 'bold',...
                'FontSize', 10);

        end
      
        %%   Define the callbacks for the Tab Buttons
%   All callbacks go to the same function with the additional argument being the Tab number
        for CountTabs = 1:NumberOfTabs
            set(TabHandles{CountTabs,2}, 'callback', ...
                {@TabSellectCallback, CountTabs});
        end
        
        
        %%   Define content for the Problem Setup Tab
        uicontrol(...
'Parent',TabHandles{1,1},...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'String','Problem Definition',...
'Style','text',...
'Position',[0.301020408163265 0.897619047619048 0.336734693877551 0.08125],...
'Children',[],...
'Tag','text2',...
'BackgroundColor',[1 1 1],...
'FontSize',20);

  NinputEdt = uicontrol(...
'Parent',TabHandles{1,1},...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'String',num2str(mlcParameters.sensors),...
'Style','edit',...
'Position',[0.0688775510204082 0.804761904761905 0.121173469387755 0.0657738095238095],...
'Callback',{@ninput_Callback,mlcParameters},...
'Children',[]);

 uicontrol(...
'Parent',TabHandles{1,1},...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'String',{  'Number of '; 'inputs' },...
'Style','text',...
'Position',[0.200255102040816 0.798958333333333 0.147959183673469 0.0677083333333334],...
'Children',[],...
'BackgroundColor',[1 1 1],...
'Tag','text3');

Noutputs = uicontrol(...
'Parent',TabHandles{1,1},...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'String',num2str(mlcParameters.controls),...
'Style','edit',...
'Position',[0.0688775510204082 0.708035714285714 0.121173469387755 0.0657738095238095],...
'Callback',{@noutput_Callback,mlcParameters},...
'BackgroundColor',[1 1 1],...
'Children',[]);

uicontrol(...
'Parent',TabHandles{1,1},...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'String',{  'Number of '; 'outputs' }',...
'Style','text',...
'Position',[0.200255102040816 0.702232142857143 0.149234693877551 0.0677083333333334],...
'BackgroundColor',[1 1 1],...
'Children',[]);

uicontrol(...
'Parent',TabHandles{1,1},...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'String','Specify inputs',...
'Style',get(0,'defaultuicontrolStyle'),...
'Position',[0.349489795918367 0.816369047619048 0.135204081632653 0.0522321428571428],...
'Callback',[],...
'Children',[]);



uicontrol(...
'Parent',TabHandles{1,1},...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'String',{  'Trees'; 'LGP';'GA' },...
'Style','popupmenu',...
'Value',find(strcmp({'tree','LGP','ga'},mlcParameters.individual_type)),...
'ValueMode',get(0,'defaultuicontrolValueMode'),...
'Position',[0.024234693877551 0.609375 0.165816326530612 0.0464285714285715],...
'Callback',[],...
'Children',[]);

 uicontrol(...
'Parent',TabHandles{1,1},...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'String','Individual types',...
'Style','text',...
'Position',[0.200255102040816 0.605505952380952 0.156887755102041 0.0464285714285714],...
'Children',[],...
'BackgroundColor',[1 1 1]);

evtext = uicontrol(...
'Parent',TabHandles{1,1},...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'String',{'Evaluation function:'; mlcParameters.evaluation_function},...
'Style','text',...
'Position',[0.590561224489796 0.787351190476191 0.207908163265306 0.0793154761904762],...
'Children',[],...
'BackgroundColor',[1 1 1]);

uicontrol(...
'Parent',TabHandles{1,1},...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'String','Choose file',...
'Style',get(0,'defaultuicontrolStyle'),...
'Position',[0.631377551020408 0.717708333333333 0.114795918367347 0.0561011904761904],...
'Callback',[],...
'Children',[],...
'Tag','choosefilebttn');

uicontrol(...
'Parent',TabHandles{1,1},...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'String','Edit file',...
'Style',get(0,'defaultuicontrolStyle'),...
'Position',[0.631377551020408 0.634523809523809 0.114795918367347 0.0561011904761904],...
'Callback',[],...
'Children',[]);

h13 = uicontrol(...
'Parent',TabHandles{1,1},...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'String',{  'Listbox' },...
'Style','listbox',...
'Value',1,...
'ValueMode',get(0,'defaultuicontrolValueMode'),...
'Position',[0.266581632653061 0.222470238095238 0.128826530612245 0.346279761904762],...
'Callback',@(hObject,eventdata)scheme_panel_one_export('opselectedbox_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'ButtonDownFcn',blanks(0),...
'DeleteFcn',blanks(0),...
'Tag','opselectedbox',...
'KeyPressFcn',blanks(0));

h14 = uicontrol(...
'Parent',TabHandles{1,1},...
'FontUnits',get(0,'defaultuicontrolFontUnits'),...
'Units','normalized',...
'String',{  'Listbox' },...
'Style','listbox',...
'Value',1,...
'ValueMode',get(0,'defaultuicontrolValueMode'),...
'Position',[0.0625 0.222470238095238 0.128826530612245 0.346279761904762],...
'Callback',@(hObject,eventdata)scheme_panel_one_export('opavailablebox_Callback',hObject,eventdata,guidata(hObject)),...
'Children',[],...
'ButtonDownFcn',blanks(0),...
'DeleteFcn',blanks(0),...
'Tag','opavailablebox',...
'KeyPressFcn',blanks(0));

        
        
   
         guidata(hTabFig,TabHandles);
end

        function ninput_Callback(hObject,eventdata,parameters)
            nsens=str2double(hObject.String);
            parameters.sensors=nsens;
        end
        
        function noutput_Callback(hObject,eventdata,parameters)
            ncont=str2double(hObject.String);
            parameters.controls=ncont;
        end

        function TabSellectCallback(~,~,SelectedTab)
%   All tab selection pushbuttons are greyed out and uipanels are set to
%   visible off, then the selected panel is made visible and it's selection
%   pushbutton is highlighted.

    %   Set up some varables
        TabHandles = guidata(gcf);
        NumberOfTabs = size(TabHandles,1)-2;
        White = TabHandles{NumberOfTabs+2,2};            % White      
        BGColor = TabHandles{NumberOfTabs+2,3};          % Light Grey
        
    %   Turn all tabs off
        for TabCount = 1:NumberOfTabs
            set(TabHandles{TabCount,1}, 'Visible', 'off');
            set(TabHandles{TabCount,2}, 'BackgroundColor', BGColor);
        end
        
    %   Enable the selected tab
        set(TabHandles{SelectedTab,1}, 'Visible', 'on');        
        set(TabHandles{SelectedTab,2}, 'BackgroundColor', White);

end