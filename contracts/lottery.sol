// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract Lottery{

    address public owner;       //持有者 控制是否開獎
    
    uint public lotteryId;      //第 N 期 lottery
    uint public playerId;       //當期玩家人數
    
    uint prize;
    uint charity;

    struct data{
        uint[6] select_num;                      //選取號碼
        uint bet;                                //下注金額
        bool IsWin;                              //是否中獎
        uint win_rank;                           //中獎等級
    }

    struct ticket{
        uint current_ticket;                     //第 n 期 目前買了 M 張票
        mapping(uint => data) Data;              //第 m 張 票 資訊
        bool ticket_IsValid;                     //是否有買票紀錄
    }

    struct player{
        uint[] lotteryid;                       //player join 哪些 N 期
        uint last_lotteryid;                    //player 最後買lottery 的期數
        mapping(uint => ticket) Ticket;         //player 第 n 期 買了哪些張票
        bool player_IsValid;                    //是否用過
    }

    mapping(address  => player) private History_Player;         //所有玩家歷史  


    struct buf_player{
        address payable player_address;
        uint bet;
        uint n_ticket;
        uint[6] select_num;
    }

    mapping(uint => buf_player) public current_player;          //當期 玩家

    struct winner_player{
        address payable winner_address;
        uint[6] select_num;
        uint bonus;
    }

    struct winner{
        uint[6] Ans_num;                //當即開獎號碼
        
        uint total_prize;               //累積獎金
        uint total_charity;             //當期捐贈金額
        address charity_this_address;   //當期收款者地址


        uint first;                     //頭獎 人數
        uint second;                    //二獎人數
        uint third;                     //三獎人數
        uint fourth;                    //四獎人數

        uint join_player;               //當期玩家總數

        mapping(uint => winner_player) First;   //頭獎 集合
        mapping(uint => winner_player) Second;  //二獎 集合
        mapping(uint => winner_player) Third;   //三獎 集合
        mapping(uint => winner_player) Fourth;  //四獎 集合

    }

    mapping(uint => winner) public History_Winner;       //歷史贏家    第N期 => winner struct

    address[]  charity_address;             //收款者地址
    uint charity_address_length;            //共N個收款者
    constructor(){
        owner=msg.sender;
        lotteryId=0;
        playerId=0;

        prize=0;
        charity=0;

        charity_address.push(owner);
        charity_address_length=1;

        History_Winner[lotteryId].total_prize=0;
        History_Winner[lotteryId].total_charity=0;
        History_Winner[lotteryId].first=0;
        History_Winner[lotteryId].second=0;
        History_Winner[lotteryId].third=0;
        History_Winner[lotteryId].fourth=0;
        History_Winner[lotteryId].join_player=0;


    }

    //1000000000000000000 wei = 1 ether 
    //2000000000000000000 wei = 2 ether     
    //3000000000000000000 wei = 3 ether 
    //4000000000000000000 wei = 4 ether 
    //5000000000000000000 wei = 5 ether 
    //6000000000000000000 wei = 6 ether 
    //10000000000000000000 wei = 10 ether 

    //買lottery
    function enter(uint a,uint b,uint c,uint d,uint e,uint f) public payable{                                   //player加入lottery
        require(msg.value%2==0,"not mode 2 equal zero");
        require(msg.value > .01 ether,"ether not enough");                          //下注金額>0.0.1ether
        require(a<b,"a b sort");
        require(b<c,"b c sort");
        require(c<d,"c d sort");
        require(d<e,"d e sort");
        require(e<f,"e f sort");
        require(a>=1,"a smaller than 1");
        require(f<=46,"a bigger than 46");
       
       
        prize+=msg.value/2;
        charity+=msg.value/2;
        
        
        
        if(History_Player[msg.sender].player_IsValid){                              //買家是否購買過


            if(lotteryId>(History_Player[msg.sender].last_lotteryid)){              //是否買過當期的票
                History_Player[msg.sender].last_lotteryid=lotteryId;                //是 => 加入當期數資訊
                History_Player[msg.sender].lotteryid.push(lotteryId);               //否 => 買過次數++

                History_Player[msg.sender].Ticket[lotteryId].ticket_IsValid=true;
                History_Player[msg.sender].Ticket[lotteryId].current_ticket=1;
                History_Player[msg.sender].Ticket[lotteryId].Data[0].bet=msg.value;
                History_Player[msg.sender].Ticket[lotteryId].Data[0].IsWin=false;
                History_Player[msg.sender].Ticket[lotteryId].Data[0].win_rank=0;
                History_Player[msg.sender].Ticket[lotteryId].Data[0].select_num=[a,b,c,d,e,f];

            }else{                                                 
                                 
                  
                uint new_ticket=History_Player[msg.sender].Ticket[lotteryId].current_ticket;
                
                History_Player[msg.sender].Ticket[lotteryId].Data[new_ticket].bet=msg.value;
                History_Player[msg.sender].Ticket[lotteryId].Data[new_ticket].IsWin=false;
                History_Player[msg.sender].Ticket[lotteryId].Data[new_ticket].win_rank=0;
                History_Player[msg.sender].Ticket[lotteryId].Data[new_ticket].select_num=[a,b,c,d,e,f];
                History_Player[msg.sender].Ticket[lotteryId].current_ticket++;  
            }
            

        }else{
            
            History_Player[msg.sender].player_IsValid=true;
            History_Player[msg.sender].lotteryid.push(lotteryId);
            History_Player[msg.sender].last_lotteryid=lotteryId;
            

            History_Player[msg.sender].Ticket[lotteryId].ticket_IsValid=true;
            History_Player[msg.sender].Ticket[lotteryId].current_ticket=1;

            History_Player[msg.sender].Ticket[lotteryId].Data[0].bet=msg.value;
            History_Player[msg.sender].Ticket[lotteryId].Data[0].IsWin=false;
            History_Player[msg.sender].Ticket[lotteryId].Data[0].win_rank=0;
            History_Player[msg.sender].Ticket[lotteryId].Data[0].select_num=[a,b,c,d,e,f];

        }


        uint N_TICKET=History_Player[msg.sender].Ticket[lotteryId].current_ticket-1;
        buf_player memory buf;
        
        buf.select_num[0]=a;
        buf.select_num[1]=b;
        buf.select_num[2]=c;
        buf.select_num[3]=d;
        buf.select_num[4]=e;
        buf.select_num[5]=f;
        buf.n_ticket=N_TICKET;
        buf.player_address=payable(msg.sender);
        buf.bet=msg.value;
        
        current_player[playerId]=buf;                                               //加入新玩家到 current_player
        delete buf;
        
        playerId++;

        
                                                                                    
    }

    // player           player             player

    // 查詢玩家 參加過lottery的所有期數
    function getHistory_player_past_lotteryid(address player_address)public view returns(uint[] memory){
        return History_Player[player_address].lotteryid;
    }

    //查詢玩家 參加果最後lottery期數
    function getHistory_player_last_lotteryid(address player_address)public view returns(uint ){
        return History_Player[player_address].last_lotteryid;
    }

    //查詢玩家是否玩過 lottery
    function getHistory_player_IsValid(address player_address)public view returns(bool ){
        return History_Player[player_address].player_IsValid;
    }

    //ticket            ticket             ticket 

    //查看玩家第N期 買了幾張票
    function getHistory_player_ticket_number(address player_address,uint lotteryid)public view returns(uint ){
        return History_Player[player_address].Ticket[lotteryid].current_ticket;
    }

    //查看玩家第N期 是否買票
    function getHistory_player_buy_ticket(address player_address,uint lotteryid)public view returns(bool ){
        return History_Player[player_address].Ticket[lotteryid].ticket_IsValid;
    }

    // data              data               data

    //查看玩家第N期 第M張票的資訊  struct
    function getHistory_player_ticket_data(address player_address,uint lotterid,uint index)public view returns(data memory ){
        return History_Player[player_address].Ticket[lotterid].Data[index];
    }

    //查看玩家第N期 第M張票的選號
    function getHistory_player_ticket_selectnum(address player_address,uint lotterid,uint index)public view returns(uint[6] memory ){
        return History_Player[player_address].Ticket[lotterid].Data[index].select_num;
    }

    //查看玩家第N期 第M張票的下注金額
    function getHistory_player_ticket_bet(address player_address,uint lotterid,uint index)public view returns(uint ){
        return History_Player[player_address].Ticket[lotterid].Data[index].bet;
    }

    //查看玩家第N期 第M張票是否中獎
    function getHistory_player_ticket_IsWin(address player_address,uint lotterid,uint index)public view returns(bool){
        return History_Player[player_address].Ticket[lotterid].Data[index].IsWin;
    }

    //查看玩家第N期 第M張票 中獎等級
    function getHistory_player_ticket_WinRank(address player_address,uint lotterid,uint index)public view returns(uint){
        return History_Player[player_address].Ticket[lotterid].Data[index].win_rank;
    }

    // money            money           money

    //查看合約total money
    function getBalance() public view returns (uint){                               //查看當前獎金池 
        return address(this).balance;
    }

    //查看合約 prize
    function getprize() public view returns (uint){                               //查看當前獎金池 
        return prize;
    }

    //查看合約 charity
    function getCharity() public view returns (uint){                               //查看當前獎金池 
        return charity;
    }

    //winner data           winner data         winner data

    //查看第N期 第M位 頭獎 data
    function getHistory_Winner_First_data(uint id,uint index) public view returns (winner_player memory){
        return History_Winner[id].First[index];
    } 

    //查看第N期 第M位 二獎 data
    function getHistory_Winner_Second_data(uint id,uint index) public view returns (winner_player memory){
        return History_Winner[id].Second[index];
    } 

    //查看第N期 第M位 三獎 data
    function getHistory_Winner_Third_data(uint id,uint index) public view returns (winner_player memory){
        return History_Winner[id].Third[index]; 
    } 

    //查看第N期 第M位 四獎 data
    function getHistory_Winner_Fourth_data(uint id,uint index) public view returns (winner_player memory){
        return History_Winner[id].Fourth[index];
    } 

    //查看第N期 收款 address
    function getHistory_Charity_Address(uint id) public view returns(address ){
        return  History_Winner[id].charity_this_address;
    }

    // open number          open number         open number

    function getRandomNumber() public view returns (uint){                          //取得隨機號碼      check
        return uint(keccak256(abi.encodePacked(owner,block.timestamp)));
    }

    //產生6個不同號碼            remix 可能out of memory    //第15次    
    
    function Ans_number_New() public  view returns (uint[6] memory){
       
        uint pick_index=0;
        uint[6] memory buf_array;
        
        uint random_number=getRandomNumber();
        while(true){ 
            while(random_number>0){
                uint pick_out=(random_number%100);
                if(pick_out<92){                       // [0,45] + [46,91]
                    uint pick_num=pick_out%46+1;       // [0,45] => [1,46]
                    
                    bool same=false;   
                    for(uint i=0;i<pick_index;i++){
                        if(buf_array[i]==pick_num){
                               same=true;
                            break;
                        }
                    }
                    if(same==false){
                        buf_array[pick_index]=pick_num;
                        pick_index++;
                    }
                }
                if(pick_index==6) break;
                random_number/=100;
            }
            if(pick_index==6) break;
            random_number=getRandomNumber();
        }
        
        for(uint i=6-1;i>0;i--){
            for(uint j=0;j<i;j++){
                require((j+1<6),"j+1>=6");
                if(buf_array[j]>buf_array[j+1]){
                    (buf_array[j],buf_array[j+1])=(buf_array[j+1],buf_array[j]);
                }
            }
        }
        return (buf_array);
    }

    // 號碼比對         check
    function rank_match(uint[6] memory test,uint[6] memory ans) public pure returns(uint ){
        
        uint same=0;
        uint t=0;
        uint a=0;
    

        while(true){
            if(test[t]==ans[a]){
                t++; 
                a++;          
                same++;
            }else if(test[t]>ans[a])    a++; 
            else                        t++;

            if(a>=6 || t>=6)            break;

        }
        delete test;
        delete ans;
        if(same==6)         return 1;      
        else if(same==5)    return 2;       
        else if(same==4)    return 3;        
        else if(same==3)    return 4;
        else                return 0;
            
        
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    //開獎 (持有者才能)  隨機產生號碼
    function pickWinner() public onlyOwner{                                         
        
        
        // TODO : 開獎

        //<1>產生6個號碼

        uint[6] memory ANS=Ans_number_New();
        
        //ANS 、 charity 、 prize 、 join_player  放入 History Winner

        History_Winner[lotteryId].Ans_num=ANS;
        History_Winner[lotteryId].total_charity=charity;
        History_Winner[lotteryId].total_prize=prize;
        History_Winner[lotteryId].join_player=playerId;
        
        //<3>比對  => if win 放進 winner data

        for(uint i=0;i<playerId;i++){
            
            uint rank = rank_match(current_player[i].select_num,ANS);           //開獎
            if(rank==0)  continue;            
            uint ticket_index =current_player[i].n_ticket;
            address Win_Add=current_player[i].player_address;
            
            if(rank==1){
                uint first_index  = History_Winner[lotteryId].first;

                History_Winner[lotteryId].First[first_index].winner_address=payable(Win_Add);
                History_Winner[lotteryId].First[first_index].select_num=current_player[i].select_num;
                History_Winner[lotteryId].first++;
                               
            }else if(rank==2){
                uint second_index = History_Winner[lotteryId].second;

                History_Winner[lotteryId].Second[second_index].winner_address=payable(Win_Add);
                History_Winner[lotteryId].Second[second_index].select_num=current_player[i].select_num;
                History_Winner[lotteryId].second++;
            
            }else if(rank==3){
                uint third_index = History_Winner[lotteryId].third;
            
                History_Winner[lotteryId].Third[third_index].winner_address=payable(Win_Add);
                History_Winner[lotteryId].Third[third_index].select_num=current_player[i].select_num;
                History_Winner[lotteryId].third++;
            
            }else if(rank==4){
                uint fourth_index = History_Winner[lotteryId].fourth;
            
                History_Winner[lotteryId].Fourth[fourth_index].winner_address=payable(Win_Add);
                History_Winner[lotteryId].Fourth[fourth_index].select_num=current_player[i].select_num;
                History_Winner[lotteryId].fourth++;
            
            }
            History_Player[Win_Add].Ticket[lotteryId].Data[ticket_index].win_rank=rank;
            History_Player[Win_Add].Ticket[lotteryId].Data[ticket_index].IsWin=true;
        }

        delete ANS;

        //<4>按人數 發錢
        uint first_count = History_Winner[lotteryId].first;
        uint second_count = History_Winner[lotteryId].second;
        uint third_count = History_Winner[lotteryId].third;
        uint fourth_count = History_Winner[lotteryId].fourth;


        uint first_share_prize;
        if(first_count>0)   first_share_prize=(prize*79)/(100*first_count);
        else                first_share_prize=0;

        uint second_share_prize;
        if(second_count>0)  second_share_prize=(prize*13)/(200*second_count);
        else                second_share_prize=0;

        uint third_share_prize;
        if(third_count>0)   third_share_prize=(prize*9)/(200*third_count);
        else                third_share_prize=0;

        uint fourth_share_prize;
        if(fourth_count>0)  fourth_share_prize=(prize)/(100*fourth_count);
        else                fourth_share_prize=0;

        for(uint i=0;i<first_count;i++){
            History_Winner[lotteryId].First[i].bonus=first_share_prize;
            History_Winner[lotteryId].First[i].winner_address.transfer(first_share_prize);
            prize-=first_share_prize;
        }
        for(uint i=0;i<second_count;i++){
            History_Winner[lotteryId].Second[i].bonus=second_share_prize;
            History_Winner[lotteryId].Second[i].winner_address.transfer(second_share_prize);
            prize-=second_share_prize;
        }
        for(uint i=0;i<third_count;i++){
            History_Winner[lotteryId].Third[i].bonus=third_share_prize;
            History_Winner[lotteryId].Third[i].winner_address.transfer(third_share_prize);
            prize-=third_share_prize;

        }
        for(uint i=0;i<fourth_count;i++){
            History_Winner[lotteryId].Fourth[i].bonus=fourth_share_prize;
            History_Winner[lotteryId].Fourth[i].winner_address.transfer(fourth_share_prize);
            prize-=fourth_share_prize;
        }

        require(prize>=0,"prize < 0 debug");
        //<5>捐款               // 捐款給創合約者 ============================================================

        uint index=getRandomNumber()%charity_address_length;            //隨機挑一個捐贈
        payable(charity_address[index]).transfer(charity);
        History_Winner[lotteryId].charity_this_address=charity_address[index];
        charity=0;

        //<*>捐款               // not use ============================================================


        //delete current player data

        for(uint i=0;i<playerId;i++){
            delete current_player[i];
        }

        lotteryId++;        //lottery 期數加一
        playerId=0;         //新一期lottery 玩家人數 零

        //初始化 下期 winner data

        History_Winner[lotteryId].total_prize=0;           
        History_Winner[lotteryId].total_charity=0;
        History_Winner[lotteryId].first=0;
        History_Winner[lotteryId].second=0;
        History_Winner[lotteryId].third=0;
        History_Winner[lotteryId].fourth=0;
        History_Winner[lotteryId].join_player=0;

        
        
      
        
    }

    //開獎 (持有者才能)  自訂頭獎號碼  "測試用"
    function Test_for_pickWinner(uint[6] memory test_ans) public onlyOwner{                                         //開獎 (持有者才能)
        
        // TODO : 開獎

        //<1>產生6個號碼

        uint[6] memory ANS=test_ans;
        
        //ANS 、 charity 、 prize 、 join_player  放入 History Winner

        History_Winner[lotteryId].Ans_num=ANS;
        History_Winner[lotteryId].total_charity=charity;
        History_Winner[lotteryId].total_prize=prize;
        History_Winner[lotteryId].join_player=playerId;
        
        //<3>比對  => if win 放進 winner data

        for(uint i=0;i<playerId;i++){
            
            uint rank = rank_match(current_player[i].select_num,ANS);           //開獎
            if(rank==0)  continue;            
            uint ticket_index =current_player[i].n_ticket;
            address Win_Add=current_player[i].player_address;
            
            if(rank==1){
                uint first_index  = History_Winner[lotteryId].first;

                History_Winner[lotteryId].First[first_index].winner_address=payable(Win_Add);
                History_Winner[lotteryId].First[first_index].select_num=current_player[i].select_num;
                History_Winner[lotteryId].first++;
                               
            }else if(rank==2){
                uint second_index = History_Winner[lotteryId].second;

                History_Winner[lotteryId].Second[second_index].winner_address=payable(Win_Add);
                History_Winner[lotteryId].Second[second_index].select_num=current_player[i].select_num;
                History_Winner[lotteryId].second++;
            
            }else if(rank==3){
                uint third_index = History_Winner[lotteryId].third;
            
                History_Winner[lotteryId].Third[third_index].winner_address=payable(Win_Add);
                History_Winner[lotteryId].Third[third_index].select_num=current_player[i].select_num;
                History_Winner[lotteryId].third++;
            
            }else if(rank==4){
                uint fourth_index = History_Winner[lotteryId].fourth;
            
                History_Winner[lotteryId].Fourth[fourth_index].winner_address=payable(Win_Add);
                History_Winner[lotteryId].Fourth[fourth_index].select_num=current_player[i].select_num;
                History_Winner[lotteryId].fourth++;
            
            }
            History_Player[Win_Add].Ticket[lotteryId].Data[ticket_index].win_rank=rank;
            History_Player[Win_Add].Ticket[lotteryId].Data[ticket_index].IsWin=true;
        }

        delete ANS;

        //<4>按人數 發錢
        uint first_count = History_Winner[lotteryId].first;
        uint second_count = History_Winner[lotteryId].second;
        uint third_count = History_Winner[lotteryId].third;
        uint fourth_count = History_Winner[lotteryId].fourth;


        uint first_share_prize;
        if(first_count>0)   first_share_prize=(prize*79)/(100*first_count);
        else                first_share_prize=0;

        uint second_share_prize;
        if(second_count>0)  second_share_prize=(prize*13)/(200*second_count);
        else                second_share_prize=0;

        uint third_share_prize;
        if(third_count>0)   third_share_prize=(prize*9)/(200*third_count);
        else                third_share_prize=0;

        uint fourth_share_prize;
        if(fourth_count>0)  fourth_share_prize=(prize)/(100*fourth_count);
        else                fourth_share_prize=0;

        for(uint i=0;i<first_count;i++){
            History_Winner[lotteryId].First[i].bonus=first_share_prize;
            History_Winner[lotteryId].First[i].winner_address.transfer(first_share_prize);
            prize-=first_share_prize;
        }
        for(uint i=0;i<second_count;i++){
            History_Winner[lotteryId].Second[i].bonus=second_share_prize;
            History_Winner[lotteryId].Second[i].winner_address.transfer(second_share_prize);
            prize-=second_share_prize;
        }
        for(uint i=0;i<third_count;i++){
            History_Winner[lotteryId].Third[i].bonus=third_share_prize;
            History_Winner[lotteryId].Third[i].winner_address.transfer(third_share_prize);
            prize-=third_share_prize;

        }
        for(uint i=0;i<fourth_count;i++){
            History_Winner[lotteryId].Fourth[i].bonus=fourth_share_prize;
            History_Winner[lotteryId].Fourth[i].winner_address.transfer(fourth_share_prize);
            prize-=fourth_share_prize;
        }

        require(prize>=0,"prize < 0 debug");
        //<5>捐款               // 捐款給創合約者 ============================================================

        uint index=getRandomNumber()%charity_address_length;            //隨機挑一個捐贈
        payable(charity_address[index]).transfer(charity);
        History_Winner[lotteryId].charity_this_address=charity_address[index];
        charity=0;

        //<*>捐款               // not use ============================================================


        //delete current player data

        for(uint i=0;i<playerId;i++){
            delete current_player[i];
        }

        lotteryId++;        //lottery 期數加一
        playerId=0;         //新一期lottery 玩家人數 零

        //初始化 下期 winner data

        History_Winner[lotteryId].total_prize=0;           
        History_Winner[lotteryId].total_charity=0;
        History_Winner[lotteryId].first=0;
        History_Winner[lotteryId].second=0;
        History_Winner[lotteryId].third=0;
        History_Winner[lotteryId].fourth=0;
        History_Winner[lotteryId].join_player=0;

        
        
        
    }

    //增加捐款者 address (持有者才能)
    function charity_add_address(address buf) public onlyOwner{
        bool exist=false;
        for(uint i=0;i<charity_address.length;i++){
            if(charity_address[i]==buf){
                exist=true;
                break;
            }
        }
        if(!exist){
            charity_address.push(buf);
            charity_address_length++;
        }
    } 

    //移除收款者 address (持有者才能)
    function charity_delet_address(uint index)public onlyOwner{
        if(index<charity_address_length){
            for(uint i=index;i<charity_address_length-1;i++){
                charity_address[i]=charity_address[i+1];
            }
            delete charity_address[charity_address_length-1];
            charity_address_length--;
        }
    }

    //查看收款者 address
    function getCharity_Address() public view returns (address[] memory){                               //查看當前獎金池 
        return charity_address;
    }
    //查看收款者 address length
    function getCharity_Address_Length() public view returns (uint){                               //查看當前獎金池 
        return charity_address_length;
    }
}