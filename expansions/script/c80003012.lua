--DRRR!! 平和岛静雄
function c80003012.initial_effect(c)
	c:SetUniqueOnField(1,0,80003012) 
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2da),aux.NonTuner(Card.IsSetCard,0x2da),1)
	c:EnableReviveLimit() 
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)	 
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c80003012.aclimit)
	e2:SetCondition(c80003012.actcon)
	c:RegisterEffect(e2)
	--destroy
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(80003012,1))
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e9:SetCategory(CATEGORY_DESTROY)
	e9:SetCode(EVENT_BATTLE_DESTROYING)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCondition(c80003012.decon)
	e9:SetTarget(c80003012.detg)
	e9:SetOperation(c80003012.deop)
	c:RegisterEffect(e9) 
end
function c80003012.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c80003012.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c80003012.decon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c80003012.defilter(c)
	return c:IsDestructable()
end
function c80003012.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c80003012.defilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c80003012.deop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80003012.defilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT,LOCATION_DECK)
end