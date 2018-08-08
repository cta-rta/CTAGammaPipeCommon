
--  Copyright (c) 2017, AGILE team
-- Authors: Nicolo' Parmiggiani <nicolo.parmiggiani@gmail.com>,
--
-- Any information contained in this software is property of the AGILE TEAM
-- and is strictly private and confidential. All rights reserved.

 DROP EVENT IF EXISTS stream_data_event;
DELIMITER |

CREATE EVENT stream_data_event     
ON SCHEDULE EVERY 1 SECOND     
DO       
	BEGIN
    
		    DECLARE stream_general_status INT;
			SELECT status INTO stream_general_status from stream_event;
            

			
		BEGIN
			DO RELEASE_LOCK('stream_data_event');
		END;
	
		IF GET_LOCK('stream_data_event', -1) AND stream_general_status = 1 THEN

		    
	BEGIN            
		DECLARE done INT DEFAULT FALSE;           
		DECLARE t_start DOUBLE;           
		DECLARE t_stop  DOUBLE;   
        DECLARE t_window_start  DOUBLE;     
        DECLARE t_window_stop  DOUBLE;    
        DECLARE new_twindow_start DOUBLE;
        DECLARE new_twindow_stop DOUBLE;
        DECLARE obsid INT UNSIGNED;     
        DECLARE datarepository_id INT UNSIGNED;     
        DECLARE pipedb_name VARCHAR (255);
		DECLARE time_step INT;
        DECLARE speed_factor INT;
        DECLARE timestep_count INT;
        DECLARE streamdata_id INT UNSIGNED;
    
		DECLARE cur1 CURSOR FOR SELECT streamdataid,observationid,datarepositoryid,tstart,tstop,twindowstart,twindowstop,pipedbname,timestep,timestepcount,speedfactor FROM stream_data WHERE streamstatus = 1;     
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;      
    
	   
		OPEN cur1;        
		read_loop: LOOP        
     
		
			FETCH cur1 INTO streamdata_id,obsid,datarepository_id,t_start,t_stop,t_window_start,t_window_stop,pipedb_name,time_step,timestep_count,speed_factor;       
            
          #  INSERT INTO log_streaming (time,comment) values (NOW(),concat('start1',streamdata_id));
				
            IF done THEN     
				LEAVE read_loop;    
			END IF;          
            
          #  INSERT INTO log_streaming (time,comment) values (NOW(),concat('start2',streamdata_id));
            
            IF time_step!=timestep_count THEN
					UPDATE stream_data SET timestepcount = timestep_count + 1 WHERE streamdataid = streamdata_id;
                    ITERATE read_loop;   
            ELSE
					UPDATE stream_data SET timestepcount = 0 WHERE streamdataid = streamdata_id;
            END IF;
            
             # INSERT INTO log_streaming (time,comment) values (NOW(),concat('start3',streamdata_id));
            
            SET new_twindow_start = t_window_stop;
            SET new_twindow_stop = t_window_stop + time_step * speed_factor;
            
            IF new_twindow_stop > (t_stop-t_start) THEN
				UPDATE stream_data SET streamstatus = 0 WHERE observationid = obsid;             
				ITERATE read_loop;
			END IF;
            
			#INSERT INTO log_streaming (time,comment) values (NOW(),concat('start4',streamdata_id));
            UPDATE evt3 SET status = 1,timerealtt = t_start + time, insert_time =  UNIX_TIMESTAMP() where observationid = obsid AND datarepositoryid = datarepository_id AND time >= new_twindow_start AND time <= new_twindow_stop;
          
			UPDATE stream_data SET twindowstart = new_twindow_start WHERE observationid = obsid;             
			UPDATE stream_data SET twindowstop = new_twindow_stop  WHERE observationid = obsid;                   
            
			#INSERT INTO log_streaming (time,comment) values (NOW(),concat('start5',streamdata_id));
			IF pipedb_name != -1  THEN
            
				#INSERT INTO log_streaming (time,comment) values (NOW(),concat('before updated repository',obsid,datarepository_id));
				#update tend of observation_to_datarepository
				#UPDATE `pipe-db-test`.observation_to_datarepository SET tenddata =  t_start + new_twindow_stop WHERE observationid =  obsid AND datarepositoryid = datarepository_id ;
				SET @qry := CONCAT("UPDATE `",pipedb_name,"`.observation_to_datarepository SET tenddata =  ",t_start," + ",new_twindow_stop," WHERE observationid =  ",obsid," AND datarepositoryid = ",datarepository_id);
				PREPARE stmt FROM @qry;
				EXECUTE stmt;
				DEALLOCATE PREPARE stmt;
			
				#INSERT INTO log_streaming (time,comment) values (NOW(),concat('updated repository',obsid,datarepository_id));
				#INSERT INTO log_streaming (time,obs_id,twindow_start,twindow_stop,comment) values (NOW(),obsid,t_start,t_stop,concat('stop',t_start,' ',new_twindow_stop+t_start,' ',obsid,' ',datarepository_id));
        
            END IF;
             
			
		END LOOP;      

		#INSERT INTO log_streaming (time,comment) values (NOW(),'stop');
		CLOSE cur1;  
        
		END;
        END IF;
        
        
		DO RELEASE_LOCK('stream_data_event');
        
	END |

DELIMITER ;