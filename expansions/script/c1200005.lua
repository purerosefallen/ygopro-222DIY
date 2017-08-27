--LA Da'ath 榮耀的拉斐兒
function c1200005.initial_effect(c)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1200005,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,1200005)
	e4:SetTarget(c1200005.tgtg)
	e4:SetOperation(c1200005.tgop)
	c:RegisterEffect(e4)
	--disable and SpecialSummon
	local e2=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1200005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetOperation(c1200005.disop)
	c:RegisterEffect(e2)


end
function c1200005.tgfilter(c)
	return c:IsCode(1200005) and c:IsAbleToGrave()
end
function c1200005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200005.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,nil,tp,LOCATION_DECK)
end
function c1200005.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1200005.tgfilter,tp,LOCATION_DECK,0,nil)
	if g then Duel.SendtoGrave(g,REASON_EFFECT) end
end
function c1200005.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c1200005.disop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g:IsContains(ec) and (re:GetHandler():IsSetCard(0xfba) or re:GetHandler():IsSetCard(0xfbc)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(1200005,2)) then
			if Duel.NegateEffect(ev) then
				Duel.SpecialSummon(ec,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
