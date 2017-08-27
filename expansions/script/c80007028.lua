--ex 静坐喝茶的幼女
function c80007028.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c80007028.splimcon)
	e2:SetTarget(c80007028.splimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e4)
	--cannot be material
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e6:SetValue(c80007028.splimit1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e7)
	local e5=e6:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5) 
	--destroy
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(80007028,0))
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_LEAVE_FIELD)
	e8:SetTarget(c80007028.target)
	e8:SetOperation(c80007028.operation)
	c:RegisterEffect(e8)
	--cannot be target
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e9:SetRange(LOCATION_PZONE)
	e9:SetTargetRange(LOCATION_ONFIELD,0)
	e9:SetTarget(c80007028.tgtg)
	e9:SetValue(aux.tgoval)
	c:RegisterEffect(e9)
	--cannot release
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetRange(LOCATION_PZONE)
	e10:SetCode(EFFECT_CANNOT_RELEASE)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetTargetRange(0,1)
	c:RegisterEffect(e10)
end
function c80007028.tgtg(e,c)
	return c:IsSetCard(0x2d9) 
end
function c80007028.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c80007028.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x2d9)
end
function c80007028.splimit1(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2d9)
end
function c80007028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c80007028.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end