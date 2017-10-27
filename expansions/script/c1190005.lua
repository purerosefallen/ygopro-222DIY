--ELF·莉莉
function c1190005.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,1190005)
	e1:SetCondition(c1190005.con1)
	e1:SetTarget(c1190005.tg1)
	e1:SetOperation(c1190005.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,1190055)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c1190005.tg2)
	e2:SetOperation(c1190005.op2)
	c:RegisterEffect(e2)	 
end
--
c1190005.named_with_ELF=1
function c1190005.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
function c1190005.cfilter(c)
	return c:IsFaceup() and c1190005.IsELF(c) and c:IsLevelAbove(3)
end
function c1190005.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1190005.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
--
function c1190005.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1190005.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--
function c1190005.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_DECK)
		c:RegisterEffect(e1,true)
	end
end
--
function c1190005.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER)
end
function c1190005.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and c1190005.filter2(chkc,e,tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c1190003.filter2,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c1190005.filter2,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.HintSelection(g)
--	Duel.SetOperationInfo(0,CATEGORY_,g,1,0,0)	
end
function c1190005.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		e1:SetCode(EFFECT_FORBIDDEN)
		e1:SetTarget(c1190005.bantg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetTarget(c1190005.bantg)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c1190005.bantg(e,c)
	return c==e:GetLabelObject()
end
