--ＤＭ 蔷薇兽
function c80009038.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_PLANT)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c80009038.ptg)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetTarget(c80009038.target1)
	e4:SetOperation(c80009038.operation1)
	c:RegisterEffect(e4)
	--battle indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c80009038.ptg(e,c)
	return c:IsRace(RACE_PLANT) and c:IsType(TYPE_MONSTER)
end
function c80009038.filter1(c)
	return c:IsControlerCanBeChanged() and (c:IsLevelBelow(8) or c:IsRankBelow(8))
end
function c80009038.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c80009038.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80009038.filter1,tp,0,LOCATION_MZONE,1,nil) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp,LOCATION_REASON_CONTROL)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c80009038.filter1,tp,0,LOCATION_MZONE,1,ft,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c80009038.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()>Duel.GetLocationCount(tp,LOCATION_MZONE) then return end
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			c:SetCardTarget(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_CONTROL)
			e1:SetValue(tp)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetCondition(c80009038.con)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
function c80009038.con(e)
	local c=e:GetOwner()
	local h=e:GetHandler()
	return c:IsHasCardTarget(h) and not c:IsDisabled()
end
function c80009038.filter(c)
	return c:IsSetCard(0x2d5) and c:IsType(TYPE_XYZ) and c:IsRace(RACE_PLANT)
end
function c80009038.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c80009038.filter,1,nil)
end