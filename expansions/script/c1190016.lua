--ELF·精灵奇迹法师
function c1190016.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1190016)
	e1:SetCost(c1190016.cost1)
	e1:SetTarget(c1190016.tg1)
	e1:SetOperation(c1190016.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,1190066)
	e2:SetCondition(c1190016.con2)
	e2:SetTarget(c1190016.tg2)
	e2:SetOperation(c1190016.op2)
	c:RegisterEffect(e2)	
end
--
c1190016.named_with_ELF=1
function c1190016.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
function c1190016.filter(c)
	return c1190016.IsELF(c) and c:IsAbleToDeck()
end
function c1190016.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1190016.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1190016.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
--
function c1190016.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--
function c1190016.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
		Duel.ConfirmDecktop(tp,1)
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		if c1190016.IsELF(tc) then
		   Duel.Damage(1-tp,400,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
	end
end
--
function c1190016.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
--
function c1190016.filter2(c,e,tp)
	return c1190016.IsELF(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(1)
end
function c1190016.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c1190016.filter2(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c1190016.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1190016.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
--
function c1190016.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end