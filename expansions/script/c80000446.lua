--ＬＰＭ 帕路奇犽
function c80000446.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c80000446.ffilter,5,true)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)	
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c80000446.efilter)
	c:RegisterEffect(e2)  
	--remove
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,0xff)
	e6:SetValue(LOCATION_DECKBOT)
	e6:SetTarget(c80000446.rmtg)
	c:RegisterEffect(e6)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000446,0))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c80000446.negcon)
	e5:SetTarget(c80000446.rmtg)
	e5:SetOperation(c80000446.rmop)
	c:RegisterEffect(e5)
	--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80000446,1))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetHintTiming(0,TIMING_MAIN_END)
	e7:SetCountLimit(1)
	e7:SetCost(c80000446.cost)
	e7:SetCondition(c80000446.condition)
	e7:SetTarget(c80000446.tdtg)
	e7:SetOperation(c80000446.tdop)
	c:RegisterEffect(e7)
end
function c80000446.ffilter(c)
	return c:IsFusionSetCard(0x2d0) and c:IsType(TYPE_FUSION) and c:GetLevel()==8
end
function c80000446.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000446.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c80000446.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c80000446.tdfilter(c)
	return c:IsAbleToDeck()
end
function c80000446.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c80000446.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c80000446.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80000446.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
end
function c80000446.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c80000446.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,0,REASON_COST)
end
function c80000446.rmfilter(c)
	return c:IsAbleToRemove() 
end
function c80000446.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c80000446.rmfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingTarget(c80000446.rmfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c80000446.rmfilter,tp,0,LOCATION_MZONE,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
		Duel.SetChainLimit(aux.FALSE)
end
function c80000446.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local g=Group.FromCards(c,tc)
	if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	Duel.RegisterEffect(e1,tp)
		local fid=c:GetFieldID()
		local rct=1
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then rct=2 end
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			if oc:IsControler(tp) then
				oc:RegisterFlagEffect(80000446,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,rct,fid)
			else
				oc:RegisterFlagEffect(80000446,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,0,rct,fid)
			end
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCondition(c80000446.retcon)
		e1:SetOperation(c80000446.retop)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			e1:SetValue(Duel.GetTurnCount())
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			e1:SetValue(0)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c80000446.retfilter(c,fid)
	return c:GetFlagEffectLabel(80000446)==fid
end
function c80000446.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(c80000446.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c80000446.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c80000446.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
end