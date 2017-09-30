--治愈的魔法使 美树沙耶加
function c11200004.initial_effect(c)
	 c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c11200004.fuscon)
	e1:SetOperation(c11200004.fusop)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200004,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,11200004)
	e2:SetCost(c11200004.cost)
	e2:SetTarget(c11200004.tg)
	e2:SetOperation(c11200004.op)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetDescription(aux.Stringid(11200004,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,11200004)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c11200004.con)
	e3:SetCost(c11200004.cost2)
	e3:SetTarget(c11200004.tdtg)
	e3:SetOperation(c11200004.tdop)
	c:RegisterEffect(e3)
   --return
   local e4=e3:Clone()
   e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
   e4:SetDescription(aux.Stringid(11200004,2))
   e4:SetTarget(c11200004.retg)
   e4:SetOperation(c11200004.reop)
   c:RegisterEffect(e4)
end
function c11200004.ffilter(c,fc)
	return c11200004.ffilter1(c,fc) or c11200004.ffilter2(c,fc)
end
function c11200004.ffilter1(c,fc)
	return c:IsFusionSetCard(0x134) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc) 
end
function c11200004.ffilter2(c,fc)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeFusionMaterial(fc) 
end
function c11200004.spfilter1(c,tp,mg,fc)
	  return mg:IsExists(c11200004.spfilter2,1,c,tp,c,fc) 
end
function c11200004.spfilter2(c,tp,mc,fc)
	return ((c11200004.ffilter1(c,fc) and c11200004.ffilter2(mc,fc))
		or (c11200004.ffilter2(c,fc) and c11200004.ffilter1(mc,fc)))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c11200004.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local mg=g:Filter(c11200004.ffilter,nil,c)
	local mg1=g:Filter(c11200004.ffilter1,nil,c)
	local mg2=g:Filter(c11200004.ffilter2,nil,c)
	local tg=Duel.GetMatchingGroup(c11200004.ffilter,tp,LOCATION_DECK,0,nil,c)
	local tg1=Duel.GetMatchingGroup(c11200004.ffilter1,tp,LOCATION_DECK,0,nil,c)
	 local tg2=Duel.GetMatchingGroup(c11200004.ffilter2,tp,LOCATION_DECK,0,nil,c)
	if gc then
		if not mg1:IsContains(gc) and not mg2:IsContains(gc) then return false end
	   if Duel.GetFlagEffect(tp,11200002)~=0 then
		return mg:IsExists(c11200004.spfilter2,1,gc,tp,gc,c) or tg:IsExists(c11200004.spfilter2,1,gc,tp,gc,c)
		else
		return mg:IsExists(c11200004.spfilter2,gc,tp,gc,c) 
end
end
	if Duel.GetFlagEffect(tp,11200002)~=0 and mg1:GetCount()==0 and
	mg2:GetCount()~=0  then
	 return tg1:IsExists(c11200004.spfilter1,1,nil,tp,mg2,c) 
   elseif Duel.GetFlagEffect(tp,11200002)~=0 and mg2:GetCount()==0 and
	mg1:GetCount()~=0  then
	return tg2:IsExists(c11200004.spfilter1,1,nil,tp,mg1,c)
	 elseif Duel.GetFlagEffect(tp,11200002)~=0 and mg:GetCount()==1 then
	return tg:IsExists(c11200004.spfilter1,1,nil,tp,mg,c)
	else
	return mg:IsExists(c11200004.spfilter1,1,nil,tp,mg,c) 
end
end
function c11200004.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local c=e:GetHandler()
	local mg=eg:Filter(c11200004.ffilter,nil,c)
	local mg1=eg:Filter(c11200004.ffilter1,nil,c)
	local mg2=eg:Filter(c11200004.ffilter2,nil,c)
	local tg=Duel.GetMatchingGroup(c11200004.ffilter,tp,LOCATION_DECK,0,nil,c)
	local tg1=Duel.GetMatchingGroup(c11200004.ffilter1,tp,LOCATION_DECK,0,nil,c)
	 local tg2=Duel.GetMatchingGroup(c11200004.ffilter2,tp,LOCATION_DECK,0,nil,c)
	local g=nil
	local sg
	if gc then
		g=Group.FromCards(gc)
		mg:RemoveCard(gc)
	else
	   if Duel.GetFlagEffect(tp,11200002)~=0 and mg1:GetCount()~=0 and
	mg2:GetCount()~=0 and tg:GetCount()>0 and mg:GetCount()>1 and Duel.SelectYesNo(tp,aux.Stringid(11200004,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=tg:FilterSelect(tp,c11200004.spfilter1,1,1,nil,tp,mg,c)
		Duel.ResetFlagEffect(tp,11200002)
		elseif Duel.GetFlagEffect(tp,11200002)~=0 and mg2:GetCount()==0 and mg1:GetCount()~=0 and tg2:GetCount()>0  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=tg2:FilterSelect(tp,c11200004.spfilter1,1,1,nil,tp,mg1,c)
		Duel.ResetFlagEffect(tp,11200002)
	   elseif Duel.GetFlagEffect(tp,11200002)~=0 and mg2:GetCount()~=0 and mg1:GetCount()==0 and tg1:GetCount()>0  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=tg1:FilterSelect(tp,c11200004.spfilter1,1,1,nil,tp,mg2,c)
		Duel.ResetFlagEffect(tp,11200002)
		 elseif Duel.GetFlagEffect(tp,11200002)~=0 and mg:GetCount()==1  then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=tg:FilterSelect(tp,c11200004.spfilter1,1,1,nil,tp,mg,c)
		Duel.ResetFlagEffect(tp,11200002)
		else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=mg:FilterSelect(tp,c11200004.spfilter1,1,1,nil,tp,mg,c)
		mg:Sub(g)
end
	end
	  if Duel.GetFlagEffect(tp,11200002)~=0 and tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11200004,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		sg=tg:FilterSelect(tp,c11200004.spfilter2,1,1,nil,tp,g:GetFirst(),c)
		Duel.ResetFlagEffect(tp,11200002)
		 else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		sg=mg:FilterSelect(tp,c11200004.spfilter2,1,1,nil,tp,g:GetFirst(),c)
end
	g:Merge(sg)
	Duel.SetFusionMaterial(g)
end
function c11200004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c11200004.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function c11200004.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	if Duel.GetLP(p)<Duel.GetLP(1-p) then
	  local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
end
function c11200004.con(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) 
end
function c11200004.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c11200004.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE,1,e:GetHandler()) and e:GetHandler():IsAbleToDeck() end
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE,1,3,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c11200004.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==tg:GetCount() and  e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(sg,REASON_EFFECT+REASON_RETURN)
	end
end
function c11200004.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED+LOCATION_GRAVE ,LOCATION_REMOVED+LOCATION_GRAVE,1,e:GetHandler())
   and e:GetHandler():IsAbleToRemove() end
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_REMOVED+LOCATION_GRAVE ,LOCATION_REMOVED+LOCATION_GRAVE,1,3,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c11200004.reop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==tg:GetCount() and e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end
