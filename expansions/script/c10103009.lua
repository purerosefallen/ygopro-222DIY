--界限龙王 卡奥斯
function c10103009.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c10103009.sprcon)
	e2:SetOperation(c10103009.sprop)
	c:RegisterEffect(e2)	
	--return to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10103009,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10103009)
	e3:SetCondition(c10103009.tdcon)
	e3:SetCost(c10103009.tdcost)
	e3:SetTarget(c10103009.tdtg)
	e3:SetOperation(c10103009.tdop)
	c:RegisterEffect(e3)
	--spsummon or addtohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10103009,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,10103109)
	e4:SetCondition(c10103009.spcon)
	e4:SetTarget(c10103009.sptg)
	e4:SetOperation(c10103009.spop)
	c:RegisterEffect(e4)
end
function c10103009.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c10103009.spfilter(c,e,tp)
	return ((c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or c:IsAbleToHand()) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x337)
end
function c10103009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10103009.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
end
function c10103009.spop(e,tp,eg,ep,ev,re,r,rp)
	local g,ft,op,c=Duel.GetMatchingGroup(c10103009.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp),Duel.GetLocationCount(tp,LOCATION_MZONE),0,e:GetHandler()
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10103009,1))
	local tc=Duel.SelectMatchingCard(tp,c10103009.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then
		local f2=ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local f1=tc:IsAbleToHand()
		if f1 and f2 then
		   op=Duel.SelectOption(tp,aux.Stringid(10103009,2),aux.Stringid(10103009,3))
		elseif f1 then
		   op=0
		elseif f2 then
		   op=1
		end
		if op==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c10103009.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10103009.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10103009.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,tp,2,REASON_COST)
end
function c10103009.costfilter(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsSetCard(0x337) and c:IsType(TYPE_MONSTER)
end
function c10103009.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,1-tp,LOCATION_ONFIELD)
end
function c10103009.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c10103009.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c10103009.rfilter(c)
	return c:IsSetCard(0x1337) and c:IsType(TYPE_MONSTER)
end
function c10103009.sprcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c10103009.rfilter,2,nil)
end
function c10103009.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c10103009.rfilter,2,2,nil)
	Duel.Release(g,REASON_COST)
end