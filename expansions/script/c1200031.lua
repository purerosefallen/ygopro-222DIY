--靜儀式 愛麗絲の万花鏡
function c1200031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1200031,0))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,1200031)
	e2:SetCondition(c1200031.sccon)
	e2:SetTarget(c1200031.sctg)
	e2:SetOperation(c1200031.scop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1200031,1))
	e3:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,1200031)
	e3:SetCondition(c1200031.spcon)
	e3:SetTarget(c1200031.sptg)
	e3:SetOperation(c1200031.spop)
	c:RegisterEffect(e3)
end
function c1200031.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c1200031.scfilter(c)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c1200031.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200031.scfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c1200031.thfilter(c,att,rec)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (c:IsAttribute(att) or c:IsRace(rec))
end
function c1200031.scop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if not Duel.IsExistingMatchingCard(c1200031.scfilter,tp,LOCATION_HAND,0,1,nil) then return false end
	local g=Duel.SelectMatchingCard(tp,c1200031.scfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local rec=tc:GetRace()
		local att=tc:GetAttribute()
		if Duel.Release(tc,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(c1200031.thfilter,tp,LOCATION_DECK,0,1,nil,att,rec) then
			if Duel.SelectYesNo(tp,aux.Stringid(1200031,2)) then
				Duel.BreakEffect()
				local sg=Duel.SelectMatchingCard(tp,c1200031.thfilter,tp,LOCATION_DECK,0,1,1,nil,att,rec)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end
function c1200031.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c1200031.spcfilter(c)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c1200031.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200031.spcfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c1200031.spfilter(c,e,tp,atk)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c1200031.spop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if not Duel.IsExistingMatchingCard(c1200031.spcfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	local g=Duel.SelectMatchingCard(tp,c1200031.spcfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local atk=tc:GetBaseAttack()
		if Duel.Release(tc,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(c1200031.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,atk) then
			if Duel.SelectYesNo(tp,aux.Stringid(1200031,3)) then
				Duel.BreakEffect()
				local sg=Duel.SelectMatchingCard(tp,c1200031.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,atk)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end





