--ELF·丰收庆典
function c1191301.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,1191301)
	e2:SetTarget(c1191301.tg1)
	e2:SetOperation(c1191301.op1)
	c:RegisterEffect(e2)  
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c1191301.tg3)
	e3:SetValue(c1191301.efilter)
	c:RegisterEffect(e3)  
--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c1191301.con4)
	e4:SetTarget(c1191301.tg4)
	e4:SetOperation(c1191301.op4)
	c:RegisterEffect(e4)
end
--
c1191301.named_with_ELF=1
function c1191301.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
function c1191301.filter1(c,e,tp)
	return c1191301.IsELF(c) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:GetLevel()==2 and not c:IsType(TYPE_SYNCHRO)
end
function c1191301.tfilter1(c,e,tp)
	return c1191301.IsELF(c) and c:IsType(TYPE_MONSTER) and c:GetLevel()==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1191301.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1191301.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1191301.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c1191301.tfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c1191301.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c1191301.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1191301.tfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c1191301.tgfilter3(c)
	return c:IsFaceup() and c1191301.IsELF(c) and c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function c1191301.tg3(e,c)
	local g=Duel.GetMatchingGroup(c1191301.tgfilter3,c:GetControler(),LOCATION_MZONE,0,nil)
	return g
end
function c1191301.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
--
function c1191301.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c1191301.filter4(c,e,tp)
	return c1191301.ELF(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1191301.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c1191301.filter4(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c1191301.filter4,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1191301.filter4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c1191301.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end