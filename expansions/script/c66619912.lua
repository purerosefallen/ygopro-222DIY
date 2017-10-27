--AIW·仙境之外的爱丽丝
function c66619912.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(Card.IsType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--dis
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564004,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCost(c66619912.cost)
	e1:SetTarget(c66619912.target)
	e1:SetOperation(c66619912.activate)
	c:RegisterEffect(e1)
	--sppp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCost(c66619912.recost)
	e2:SetCondition(c66619912.retcon)
	e2:SetTarget(c66619912.rettg)
	e2:SetOperation(c66619912.retop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53804307,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c66619912.hspcost)
	e3:SetTarget(c66619912.hsptg)
	e3:SetOperation(c66619912.hspop)
	c:RegisterEffect(e3)
end
function c66619912.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66619912.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c66619912.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c66619912.cfilter2(c,tp)
	return c:GetSummonPlayer()==1-tp
end
function c66619912.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return rp~=tp and eg:IsExists(c66619912.cfilter2,1,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,0,1-tp,0)
end
function c66619912.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e5:SetValue(1)
		e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e5)
	end
end
function c66619912.retcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c66619912.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost()
end
function c66619912.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66619912.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c66619912.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c66619912.spfilter(c,e,tp)
	return c:IsCode(66619907) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c66619912.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c66619912.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c66619912.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c66619912.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c66619912.cfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost()
end
function c66619912.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66619912.cfilter1,tp,LOCATION_ONFIELD,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c66619912.cfilter1,tp,LOCATION_ONFIELD,0,3,3,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c66619912.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_SYNCHRO) and c:GetAttack()>0
end
function c66619912.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c66619912.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66619912.filter1,tp,LOCATION_MZONE,0,1,nil) and Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c66619912.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	local atk=g:GetFirst():GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c66619912.hspop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT) then
	   Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	   Duel.BreakEffect()
	   local c=e:GetHandler()
	   if not c:IsRelateToEffect(e) then return end
	   if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetMZoneCount(tp)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(c,REASON_RULE)
	   end
	end
end