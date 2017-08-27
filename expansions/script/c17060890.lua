--電波型パーソナリテイーズ
function c17060890.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),2)
	c:EnableReviveLimit()
	--pendulum set ＆ atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060890,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c17060890.pscon)
	e1:SetTarget(c17060890.pstg)
	e1:SetOperation(c17060890.psop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060890,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c17060890.sptg)
	e2:SetOperation(c17060890.spop)
	c:RegisterEffect(e2)
end
c17060890.is_named_with_Waves_Type=1
function c17060890.IsWaves_Type(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Waves_Type
end
function c17060890.pscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c17060890.psfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17060890.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c17060890.psfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c17060890.psop(e,tp,eg,ep,ev,re,r,rp)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c17060890.psfilter(chkc) end
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c17060890.psfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	local atk=tc:GetLeftScale()
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(math.ceil(atk*100))
			c:RegisterEffect(e2)
		end
	end
end
function c17060890.filter(c,e,tp,zone)
	return c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c17060890.scfilter(c,pc)
	return c:GetLeftScale()>=3
end
function c17060890.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c17060890.scfilter(chkc) end
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone()
		return zone~=0 and Duel.IsExistingMatchingCard(c17060890.filter,tp,LOCATION_HAND,0,1,nil,e,tp,zone)
		and Duel.IsExistingTarget(c17060890.scfilter,tp,LOCATION_PZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c17060890.scfilter,tp,LOCATION_PZONE,0,1,1,nil)
end
function c17060890.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetLeftScale()>=3 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(-3)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		tc:RegisterEffect(e2)
		local zone=e:GetHandler():GetLinkedZone()
		if zone==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c17060890.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end