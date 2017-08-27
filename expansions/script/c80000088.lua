--口袋妖怪 Mega火焰鸡
function c80000088.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,10000000) 
	--spsummon condition
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_SPSUMMON_CONDITION)
	e7:SetValue(aux.FALSE)
	c:RegisterEffect(e7)   
	--ack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(1)
	e1:SetCondition(c80000088.con3)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetCondition(c80000088.dircon)
	c:RegisterEffect(e2)
	--remove1
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(80000088,1))
	e8:SetCategory(CATEGORY_REMOVE)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_BATTLED)
	e8:SetCondition(c80000088.rmcon)
	e8:SetTarget(c80000088.rmtg)
	e8:SetOperation(c80000088.rmop)
	c:RegisterEffect(e8)
	--act limit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE)
	e9:SetTargetRange(0,1)
	e9:SetCondition(c80000088.con5)
	e9:SetValue(c80000088.aclimit)
	c:RegisterEffect(e9)
	--cannot spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c80000088.con6)
	e3:SetTarget(c80000088.splimit)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetDescription(aux.Stringid(80000088,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCondition(c80000088.con8)
	e4:SetOperation(c80000088.op)
	c:RegisterEffect(e4)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000088,2))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,0x1e0)
	e5:SetTarget(c80000088.target)
	e5:SetOperation(c80000088.operation)
	c:RegisterEffect(e5)
	--disable spsummon
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE)
	e14:SetTargetRange(1,1)
	e14:SetTarget(c80000088.tg1)
	c:RegisterEffect(e14)  
end
function c80000088.tg1(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c80000088.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c80000088.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA+LOCATION_DECK+LOCATION_GRAVE)
end
function c80000088.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) 
end
function c80000088.filter5(c,att)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c80000088.con5(e)
	return Duel.IsExistingMatchingCard(c80000088.filter5,0,0,LOCATION_MZONE,1,nil,TYPE_RITUAL)
end
function c80000088.filter6(c,att)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c80000088.con6(e)
	return Duel.IsExistingMatchingCard(c80000088.filter6,0,0,LOCATION_MZONE,1,nil,TYPE_SYNCHRO)
end
function c80000088.filter8(c,att)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c80000088.con8(e)
	return Duel.IsExistingMatchingCard(c80000088.filter8,0,0,LOCATION_MZONE,1,nil,TYPE_FUSION)
end
function c80000088.filter7(c,att)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c80000088.con7(e)
	return Duel.IsExistingMatchingCard(c80000088.filter7,0,0,LOCATION_MZONE,1,nil,TYPE_XYZ)
end
function c80000088.dircon(e)
	return e:GetHandler():GetAttackAnnouncedCount()>0
end
function c80000088.filter3(c,att)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c80000088.con3(e)
	return Duel.IsExistingMatchingCard(c80000088.filter3,0,0,LOCATION_MZONE,1,nil,TYPE_PENDULUM)
end
function c80000088.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsStatus(STATUS_OPPO_BATTLE)
end
function c80000088.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetLabelObject(),1,0,0)
end
function c80000088.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end
function c80000088.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c80000088.op(e,tp,eg,ep,ev,re,r,rp,chk)
		Duel.Draw(tp,1,REASON_EFFECT)
end
function c80000088.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove() and c:IsType(TYPE_XYZ)
end
function c80000088.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c80000088.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000088.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c80000088.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c80000088.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetOperation(c80000088.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c80000088.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end

