--ENS·风导星歌、黎明之景
if not pcall(function() require("expansions/script/c37564765") end) then require("script/c37564765") end
function c57310003.initial_effect(c)
	Senya.ens(c,57310003)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564765,5))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(Senya.SelfReleaseCost)
	e1:SetCondition(c57310003.condition)
	e1:SetTarget(c57310003.target)
	e1:SetOperation(c57310003.activate)
	c:RegisterEffect(e1)
end
function c57310003.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c57310003.filter(c)
	return c:IsAttackPos() and c:IsAbleToRemove()
end
function c57310003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c57310003.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c57310003.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c57310003.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c57310003.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		Senya.ensop(57310003)(e,tp,eg,ep,ev,re,r,rp)
	end
end