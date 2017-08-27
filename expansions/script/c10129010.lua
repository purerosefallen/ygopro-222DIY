--地狱魔犬 三头犬 刻耳柏洛斯
function c10129010.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),3,false)  
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c10129010.splimit)
	c:RegisterEffect(e0)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10129010,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMING_ATTACK+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10129010.rmtg)
	e1:SetOperation(c10129010.rmop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
end
function c10129010.rmfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:GetLevel()==1 and c:IsAbleToRemove()
end
function c10129010.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10129010.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10129010.rmfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c10129010.rmfilter,tp,LOCATION_MZONE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),tp,LOCATION_MZONE)
end
function c10129010.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	if Duel.Remove(tg,0,REASON_EFFECT+REASON_TEMPORARY)==0 then return end
	local sg=Duel.GetOperatedGroup()
		local sc=sg:GetFirst()
		while sc do
			 if Duel.GetCurrentPhase()==PHASE_STANDBY then
				sc:RegisterFlagEffect(10129010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,2)
			 else
				sc:RegisterFlagEffect(10129010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,1)
			 end
		   sc=sg:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c10129010.retcon)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		e1:SetCountLimit(1)
		sg:KeepAlive()
		e1:SetLabelObject(sg)
		e1:SetOperation(c10129010.retop)
		Duel.RegisterEffect(e1,tp)
	   local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	   if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10129010,2)) then 
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		  local g=dg:Select(tp,1,1,nil)
				Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	   end
end
function c10129010.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c10129010.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c10129010.retfilter,nil)
	if sg:GetCount()<=0 then return end
	local tg=sg:Clone()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft<tg:GetCount() then
	   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10129010,1))
	   tg=sg:Select(tp,ft,ft,nil)
	end
	local tc=tg:GetFirst()
	while tc do
		if Duel.ReturnToField(tc) then
		   local e1=Effect.CreateEffect(tc)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_SET_ATTACK)
		   e1:SetValue(2300)
		   e1:SetReset(RESET_EVENT+0x1ff0000)
		   tc:RegisterEffect(e1)
		end
	tc=tg:GetNext()
	end
	sg:DeleteGroup()
end
function c10129010.retfilter(c)
	return c:GetFlagEffect(10129010)~=0
end
function c10129010.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+101
end