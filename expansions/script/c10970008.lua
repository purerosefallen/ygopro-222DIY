--纸上台本撰写者 克丽索贝莉露
function c10970008.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(10970008)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10970008,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c10970008.cost)
	e2:SetTarget(c10970008.sptg)
	e2:SetOperation(c10970008.spop)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c10970008.value)
	c:RegisterEffect(e3)
end
function c10970008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10970008.filter(c,e,tp)
	return c:IsSetCard(0x2233) and c:IsType(TYPE_FIELD) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x2233,0x1011,6,1700,3000,RACE_SPELLCASTER,ATTRIBUTE_DARK)
end
function c10970008.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c10970008.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10970008.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10970008.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10970008.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c10970008.filter(tc,e,tp) then
		tc:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
		local e0=Effect.CreateEffect(tc)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_ADD_SETCODE)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		e0:SetValue(0x1233)
		tc:RegisterEffect(e0,true)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x47e0000)
		e2:SetValue(LOCATION_HAND)
		tc:RegisterEffect(e2,true)
		tc:AddMonsterAttributeComplete()
		Duel.SpecialSummonComplete()
	end
end
function c10970008.atkfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x2233)
end
function c10970008.value(e,c)
	return Duel.GetMatchingGroupCount(c10970008.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*500
end