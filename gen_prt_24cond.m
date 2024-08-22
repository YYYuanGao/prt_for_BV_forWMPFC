%% prt
Step0_Parameters;

Cond_name = {'ori15_sample','ori15_delay','ori15_test','ori15_ITI',...
    'ori75_sample','ori75_delay','ori75_test','ori75_ITI',...
    'ori135_sample','ori135_delay','ori135_test','ori135_ITI',...
    'ori195_sample','ori195_delay','ori195_test','ori195_ITI',...
    'ori255_sample','ori255_delay','ori255_test','ori255_ITI',...
    'ori315_sample','ori315_delay','ori315_test','ori315_ITI'};

for subi = subi_used
    Curr_Subj = SubID{subi};

    for sesi = sess_used
        Curr_Sess = Sess_Name{sesi};
        Curr_JKID = SubInfo{strcmp(SubInfo(:,1),Curr_Subj),strcmp(SubInfo(1,:),['JKID_' Curr_Sess])};

        Curr_RunID = SubInfo{strcmp(SubInfo(:,1),Curr_Subj),strcmp(SubInfo(1,:),['SeriesID_' Curr_Sess])};
        Curr_RunID1 = SubInfo{strcmp(SubInfo(:,1),Curr_Subj),strcmp(SubInfo(1,:),['RunID_' Curr_Sess])};
        Curr_RunNum= length(Curr_RunID);

        if Curr_RunNum > 0  % only if we have data in this session

            prt_vol  = zeros(TR_Num,1);
            for runi = 1:Curr_RunNum
                curr_results = load([BehaviouralDir Curr_Subj '\' Curr_Subj '_Sess' num2str(sesi) '_spatialTask__color_run' num2str(Curr_RunID1(runi)) '.mat']);

                for trial_i = 1:TrialNumPerRun
                    prt_vol((1 + (trial_i-1)*TrialDuration),1)  = ((curr_results.results(trial_i,3) - 15)/60)*4+1;
                    prt_vol(((2:6) + (trial_i-1)*TrialDuration),1)  = ((curr_results.results(trial_i,3) - 15)/60)*4+2;
                    prt_vol((7 + (trial_i-1)*TrialDuration),1)  = ((curr_results.results(trial_i,3) - 15)/60)*4+3;
                    prt_vol(((8:12) + (trial_i-1)*TrialDuration),1)  = ((curr_results.results(trial_i,3) - 15)/60)*4+4;

                end
                clear curr_results
            end
            prt_vol (217:218) = 4;
        end
    end

    events = Cond_name;
    % color = {[255 0 0],[0 255 0],[0 0 255],[255 25 0],[255 0 255],[0 255 255],[35 35 35],[115 115 115],[195 195 195]};
    color = {[196 81 92],[255 135 142],[255 190 196],[255 229 218],...
        [234 106 53],[255 191 132],[244 201 161],[233 220 208],...
        [229 197 53],[233 208 98],[235 225 122],[229 225 178],...
        [0 117 93],[0 159 127],[215 230 219],[240 252 258],...
        [34 142 225],[0 175 237],[0 203 218],[164 226 231],...
        [96 5 122],[163 81 187],[182 142 194],[211 193 216]};

    ncond = length(events);

    fout = fopen([Curr_JKID '_' Sess_Name{sesi} '.prt'],'wt');

    fprintf(fout, '\n');
    fprintf(fout, 'FileVersion:        2\n');
    fprintf(fout, '\n');
    fprintf(fout, 'ResolutionOfTime:   Volumes\n');
    fprintf(fout, '\n');
    fprintf(fout, 'Experiment:         %s\n',[Curr_JKID '_' Sess_Name{sesi}]);
    fprintf(fout, '\n');
    fprintf(fout, 'BackgroundColor:    0 0 0\n');
    fprintf(fout, 'TextColor:          255 255 255\n');
    fprintf(fout, 'TimeCourseColor:    255 255 255\n');
    fprintf(fout, 'TimeCourseThick:    3\n');
    fprintf(fout, 'ReferenceFuncColor: 0 0 80\n');
    fprintf(fout, 'ReferenceFuncThick: 3\n');
    fprintf(fout, '\n');
    fprintf(fout, 'NrOfConditions:  %d\n',ncond);
    fprintf(fout, '\n');

    for cond_i=1:ncond
        fprintf(fout,'%s\n',events{cond_i});
        fprintf(fout, '\n');
        temp_cond = find(prt_vol == cond_i);
        fprintf(fout, '\n');
        fprintf(fout,'%d\n',length(temp_cond));
        fprintf(fout, '\n');
        for temp_condi = 1:length(temp_cond)
            fprintf(fout,'%d %d\n',[temp_cond(temp_condi) temp_cond(temp_condi)]);
        end

        fprintf(fout,'\n');
        fprintf(fout,'Color: %d %d %d\n', color{cond_i});
        fprintf(fout,'\n');
    end

    if fout ~= 1
        fclose(fout);
    end
end

delete *.asv