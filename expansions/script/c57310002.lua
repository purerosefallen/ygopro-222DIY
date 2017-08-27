--ENS·死奏怜音、玲珑之终
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function c57310002.initial_effect(c)
	Senya.ens(c,57310002)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37564765,5))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCountLimit(1,57310002)
	e3:SetCondition(c57310002.discon)
	e3:SetCost(Senya.SelfReleaseCost)
	e3:SetTarget(c57310002.distg)
	e3:SetOperation(c57310002.disop)
	c:RegisterEffect(e3)
	local e1=e3:Clone()
	e1:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e1)
	local e2=e3:Clone()
	e2:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e2)
end
function c57310002.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c57310002.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c57310002.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	Senya.ensop(57310002)(e,tp,eg,ep,ev,re,r,rp)
end