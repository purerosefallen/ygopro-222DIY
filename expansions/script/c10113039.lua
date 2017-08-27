--时之女神 瑞亚
function c10113039.initial_effect(c)
	c:EnableReviveLimit()
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10113039,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c10113039.drcon)
	e1:SetTarget(c10113039.drtg)
	e1:SetOperation(c10113039.drop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(10113039,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10113039.rmcon)
	e2:SetTarget(c10113039.rmtg)
	e2:SetOperation(c10113039.rmop)
	c:RegisterEffect(e2)
end
function c10113039.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c10113039.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c10113039.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsControler(tp) and Duel.Remove(c,nil,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCountLimit(1)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			e1:SetValue(Duel.GetTurnCount())
		else
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			e1:SetValue(0)
		end
		e1:SetCondition(c10113039.retcon)
		e1:SetOperation(c10113039.retop)
		c:RegisterEffect(e1)
	end
end
function c10113039.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetValue()
end
function c10113039.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10113039.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	Duel.Hint(HINT_CARD,0,10113039)
	if tc:IsForbidden() then 
		Duel.SendtoGrave(tc,REASON_RULE)
	elseif Duel.ReturnToField(tc) and tc:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(10113039,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		local b3=Duel.IsExistingMatchingCard(c10113039.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp)
		local op=0
		if b2 and b3 then
		   op=Duel.SelectOption(tp,aux.Stringid(10113039,3),aux.Stringid(10113039,4),aux.Stringid(10113039,5))
		elseif b2 then
		   op=Duel.SelectOption(tp,aux.Stringid(10113039,3),aux.Stringid(10113039,4))
		elseif b3 then
		   op=Duel.SelectOption(tp,aux.Stringid(10113039,3),aux.Stringid(10113039,5))
		   if op==1 then op=2 end
		else
		   op=Duel.SelectOption(tp,aux.Stringid(10113039,3))
		end
		if op==0 then
		   local e1=Effect.CreateEffect(tc)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		   e1:SetValue(tc:GetAttack()*2)
		   e1:SetReset(RESET_EVENT+0x1ff0000)
		   tc:RegisterEffect(e1)
		elseif op==1 then
		   local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		   Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		elseif op==2 then
		   local tc=Duel.SelectMatchingCard(tp,c10113039.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp):GetFirst()
		   if not tc:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			   local e1=Effect.CreateEffect(tc)
			   e1:SetType(EFFECT_TYPE_SINGLE)
			   e1:SetCode(EFFECT_DISABLE)
			   e1:SetReset(RESET_EVENT+0x1fe0000)
			   tc:RegisterEffect(e1,true)
			   local e2=Effect.CreateEffect(tc)
			   e2:SetType(EFFECT_TYPE_SINGLE)
			   e2:SetCode(EFFECT_DISABLE_EFFECT)
			   e2:SetReset(RESET_EVENT+0x1fe0000)
			   tc:RegisterEffect(e2,true)
		   end
		end
	end
	e:Reset()
end
function c10113039.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c10113039.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10113039.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end