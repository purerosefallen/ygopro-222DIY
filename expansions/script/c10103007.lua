--界限龙 布内
function c10103007.initial_effect(c)
	c:EnableUnsummonable()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10103007,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,10103007)
	e1:SetCost(c10103007.tgcost)
	e1:SetTarget(c10103007.tgtg)
	e1:SetOperation(c10103007.tgop)
	c:RegisterEffect(e1)
	--rit summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(10103007,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10103107)
	e2:SetTarget(c10103007.rittg)
	e2:SetOperation(c10103007.ritop)
	c:RegisterEffect(e2)
	c10103007[c]=e2
end
function c10103007.ritfilter(c,e,tp,m,rc)
	if not c:IsSetCard(0x337) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if not mg:IsContains(rc) then return false
	else
	   local mg2,rlv=mg:Clone(),rc:GetRitualLevel(c)
	   mg2:RemoveCard(rc)
	   return mg2:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel()-rlv,1,1,c)
	end
end
function c10103007.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c10103007.ritfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,mg,c) and c:IsRelateToEffect(e)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c10103007.ritop(e,tp,eg,ep,ev,re,r,rp)
	local mg,c=Duel.GetRitualMaterial(tp),e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10103007.ritfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,mg,c):GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if not mg:IsContains(c) then return end
		local mg2,rlv=mg:Clone(),c:GetRitualLevel(tc)
		mg2:RemoveCard(c)
		--Duel.SetSelectedCard(c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg2:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel()-rlv,1,1,tc)
		mat:AddCard(c)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c10103007.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10103007.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:IsSetCard(0x337)
end
function c10103007.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10103007.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10103007.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10103007.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end