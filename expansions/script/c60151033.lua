--蜕变的愿望
function c60151033.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE)
	e1:SetCountLimit(1,60151033+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c60151033.cost)
	e1:SetOperation(c60151033.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c60151033.cost2)
	e2:SetTarget(c60151033.target)
	e2:SetOperation(c60151033.operation2)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c60151033.condition2)
	e3:SetOperation(c60151033.operation3)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c60151033.condition3)
	e4:SetOperation(c60151033.operation3)
	c:RegisterEffect(e4)
end
function c60151033.filter2(c,e,tp)
	return c:IsSetCard(0x5b23) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER)
end
function c60151033.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c60151033.filter2,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c60151033.filter2,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c60151033.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	--
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetTarget(c60151033.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetLabel(0)
	e1:SetCondition(c60151033.drcon)
	e1:SetOperation(c60151033.drop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c60151033.splimit(e,c,tp,sumtp,sumpos)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_FUSION) or c:IsType(TYPE_XYZ))
end
function c60151033.cfilter(c,tp)
	return c:IsControler(1-tp) and (c:IsSummonType(SUMMON_TYPE_XYZ) or c:IsSummonType(SUMMON_TYPE_FUSION))
end
function c60151033.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60151033.cfilter,1,nil,tp)
end
function c60151033.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		Duel.Hint(HINT_CARD,0,60151033)
		Duel.Recover(tp,1000,REASON_EFFECT)
		e:GetHandler():AddCounter(0x101b,1)
	end
end
function c60151033.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x101b)>0 end
	local ct=e:GetHandler():GetCounter(0x101b)
	e:SetLabel(ct*1000)
	e:GetHandler():RemoveCounter(tp,0x101b,ct,REASON_COST)
end
function c60151033.filter(c,e,tp)
	return c:IsSetCard(0x5b23) and c:IsType(TYPE_MONSTER)
end
function c60151033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60151033.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60151033.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.IsExistingMatchingCard(c60151033.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)==0 then 
		local c=e:GetHandler()
		Duel.Destroy(c,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60151033.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local atk=tc:GetAttack()
	local val=e:GetLabel()
	if atk<=val and tc:IsType(TYPE_XYZ) then
		local c=e:GetHandler()
		if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0 then
			c:CancelToGrave()
			Duel.Overlay(tc,Group.FromCards(c))
		end
	else if atk<=val and tc:IsType(TYPE_FUSION) then
			local c=e:GetHandler()
			Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end
function c60151033.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetCounter(0x101b)==0
end
function c60151033.condition3(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c60151033.filter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,1,nil)
end
function c60151033.operation3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	Duel.Destroy(c,REASON_EFFECT)
end