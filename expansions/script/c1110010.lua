--蛰居·风雪旖旎
function c1110010.initial_effect(c)
--
	c:EnableReviveLimit()
--
	aux.EnableSpiritReturn(c,EVENT_SPSUMMON_SUCCESS)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c1110010.con2)
	e2:SetOperation(c1110010.op2)
	c:RegisterEffect(e2)
--	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1110010,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_COUNTER)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,1110010)
	e3:SetTarget(c1110010.tg3)
	e3:SetOperation(c1110010.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c1110010.con4)
	e4:SetTarget(c1110010.tg4)
	e4:SetOperation(c1110010.op4)
	c:RegisterEffect(e4)
end
--
function c1110010.IsLq(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lq
end
--
function c1110010.cfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c1110011.IsLq(c) and c:IsAbleToDeckAsCost()
end
function c1110010.con2(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c1110010.cfilter2,tp,LOCATION_GRAVE,0,1,nil)
end
--
function c1110010.op2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1110010.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
--
function c1110010.tfilter3(c)
	return c1110010.IsLq(c) and c:IsAbleToGrave() and c:IsType(TYPE_SPELL)
end
function c1110010.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110010.tfilter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
--
function c1110010.ofilter3(c)
	return c:IsCanAddCounter(0x1111,1) and c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
function c1110010.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1110010.tfilter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c1110010.ofilter3,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1110010,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
			local g2=Duel.SelectMatchingCard(tp,c1110010.ofilter3,tp,LOCATION_ONFIELD,0,1,1,nil)
			if g2:GetCount()>0 then
				local tc2=g2:GetFirst()
				tc2:AddCounter(0x1111,1)
			end
		end
	end
end
--
function c1110010.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT) and c::GetPreviousControler()==tp
end
--
function c1110010.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
--
function c1110010.op4(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end
--