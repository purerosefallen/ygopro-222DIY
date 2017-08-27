--星食邪龙 尼德霍格
function c10113091.initial_effect(c)
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
	e2:SetCondition(c10113091.spcon)
	e2:SetOperation(c10113091.spop)
	c:RegisterEffect(e2) 
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c10113091.antarget)
	c:RegisterEffect(e3) 
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10113091,0))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	e4:SetTarget(c10113091.retg)
	e4:SetOperation(c10113091.reop)
	c:RegisterEffect(e4)  
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10113091,1))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c10113091.descon)
	e5:SetTarget(c10113091.destg)
	e5:SetOperation(c10113091.desop)
	c:RegisterEffect(e5)
end
function c10113091.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c10113091.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,g:GetCount()*300)
end
function c10113091.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*300,REASON_EFFECT,true)
		Duel.Damage(tp,ct*300,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end
function c10113091.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local rec=bc:GetAttack()
	if rec<0 then rec=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c10113091.reop(e,tp,eg,ep,ev,re,r,rp)
	local p,r=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,r,REASON_EFFECT)
end
function c10113091.antarget(e,c)
	return c~=e:GetHandler()
end
function c10113091.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local t=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	local s=Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
	return t-s>=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c10113091.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end