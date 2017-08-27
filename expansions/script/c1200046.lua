--LA Da'ath 慈悲的然基兒
function c1200046.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfba),4,2)
	c:EnableReviveLimit()
	--change effect
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(1200046,0))
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetCode(EVENT_CHAINING)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e8:SetCountLimit(1)
	e8:SetCost(c1200046.chcost)
	e8:SetCondition(c1200046.chcon)
	e8:SetTarget(c1200046.chtg)
	e8:SetOperation(c1200046.chop)
	c:RegisterEffect(e8)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(1200046,1))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCountLimit(1,1200046+EFFECT_COUNT_CODE_DUEL)
	e6:SetCondition(c1200046.spcon)
	e6:SetTarget(c1200046.sptg)
	e6:SetOperation(c1200046.spop)
	c:RegisterEffect(e6)
end
function c1200046.chcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_TRAP+TYPE_SPELL) and rp~=tp
end
function c1200046.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xfbc) and c:IsDestructable()
end
function c1200046.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1200046.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200046.filter,rp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c1200046.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c1200046.repop)
end
function c1200046.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsType(TYPE_TRAP+TYPE_SPELL) then
		c:CancelToGrave(false)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1200046.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c1200046.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():GetOverlayCount()~=0
end
function c1200046.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true) and c:IsSetCard(0xfba) and c:IsType(TYPE_XYZ)
end
function c1200046.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c1200046.spfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c1200046.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1200046.spfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler(),e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)>0 then
			tc:CompleteProcedure()
			Duel.BreakEffect()
			Duel.Overlay(tc,Group.FromCards(e:GetHandler()))
		end
	end
end