--界限龙 蒂雅玛特
function c10103005.initial_effect(c)
	c:EnableUnsummonable()
	--addtohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10103005,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,10103005)
	e1:SetCost(c10103005.thcost)
	e1:SetTarget(c10103005.thtg)
	e1:SetOperation(c10103005.thop)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10103005,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10103105)
	e2:SetTarget(c10103005.syntg)
	e2:SetOperation(c10103005.synop)
	c:RegisterEffect(e2)
	c10103005[c]=e2 
end
function c10103005.synfilter(c,tp,mc)
	return c:IsSetCard(0x337) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsOnField()) and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,Group.FromCards(c,mc))
end
function c10103005.syntg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c10103005.synfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,tp,c) end
end
function c10103005.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c10103005.synfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,c,tp,c)
	if not c:IsRelateToEffect(e) or mg:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local mc=mg:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local syng=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil,Group.FromCards(c,mc))
	Duel.SynchroSummon(tp,syng:GetFirst(),nil,Group.FromCards(c,mc))
	Duel.ShuffleHand(tp)
end
function c10103005.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10103005.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0x337)
end
function c10103005.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c10103005.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10103005.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10103005.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10103005.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
