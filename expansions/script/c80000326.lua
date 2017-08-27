--Lure Ball
function c80000326.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c80000326.condition)
	e1:SetTarget(c80000326.target)
	e1:SetOperation(c80000326.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000326,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c80000326.con)
	e2:SetTarget(c80000326.tg)
	e2:SetOperation(c80000326.op)
	c:RegisterEffect(e2)
end
function c80000326.condition(e,tp,eg,ep,ev,re,r,rp)
	local att=eg:GetFirst()
	return att:IsFaceup() and att:IsSetCard(0x2d0)
end
function c80000326.filter(c,e,tp)
	return c:IsSetCard(0x2d0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(ATTRIBUTE_WATER) 
end
function c80000326.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return false end
	if chk==0 then return tg:IsOnField() and tg:IsAbleToRemove() and tg:IsCanBeEffectTarget(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c80000326.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetTargetCard(tg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c80000326.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c80000326.activate(e,tp,eg,ep,ev,re,r,rp)
	local ex,sg=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local ex,dg=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local sc=sg:GetFirst()
	local dc=dg:GetFirst()
	if dc:IsRelateToEffect(e) and dc:IsAttackPos() then
		Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
		if sc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and sc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c80000326.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c80000326.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c80000326.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
end